import 'package:drift/drift.dart';
import 'package:fitness_app/database/database.dart';

/// Local midnight at the start of [time]'s day.
DateTime startOfDay(DateTime time) => DateTime(time.year, time.month, time.day);

/// Local midnight at the start of the day after [time].
DateTime startOfNextDay(DateTime time) =>
    DateTime(time.year, time.month, time.day + 1);

/// Today's session (in local time), or null if none was created today.
///
/// If more than one exists (e.g. from an older build), the earliest is used.
Future<DailySessionData?> findTodaysSession(
  AppDatabase database, {
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  return (database.select(database.dailySession)
        ..where((s) => s.createdAt.isBiggerOrEqualValue(startOfDay(today)))
        ..where((s) => s.createdAt.isSmallerThanValue(startOfNextDay(today)))
        ..orderBy([(s) => OrderingTerm.asc(s.createdAt)])
        ..limit(1))
      .getSingleOrNull();
}

/// Starts today's session for [planId], unless one already exists.
///
/// Returns the id of today's session either way.
Future<int> startTodaysSession(
  AppDatabase database,
  int planId, {
  DateTime? now,
}) {
  return database.transaction(() async {
    final existing = await findTodaysSession(database, now: now);
    if (existing != null) return existing.id;

    final exercises = await (database.select(
      database.workoutExercise,
    )..where((w) => w.planId.equals(planId))).get();

    final sessionId = await database
        .into(database.dailySession)
        .insert(
          DailySessionCompanion.insert(
            planId: planId,
            createdAt: now == null ? const Value.absent() : Value(now),
          ),
        );

    for (final exercise in exercises) {
      await database
          .into(database.sessionExerciseStatus)
          .insert(
            SessionExerciseStatusCompanion.insert(
              dailySessionId: sessionId,
              exerciseId: exercise.exerciseId,
            ),
          );
    }

    return sessionId;
  });
}

/// The most recently logged weight, or null if none has been logged.
Future<WeightData?> findLatestWeight(AppDatabase database) {
  return (database.select(database.weight)
        ..orderBy([(w) => OrderingTerm.desc(w.loggedAt)])
        ..limit(1))
      .getSingleOrNull();
}

/// Saves [value] as today's weight, replacing today's entry if there is one.
Future<void> saveTodaysWeight(
  AppDatabase database,
  double value, {
  DateTime? now,
}) {
  // Round to one decimal so repeated +0.1 steps don't store 70.30000000000001.
  final rounded = (value * 10).roundToDouble() / 10;
  final today = now ?? DateTime.now();

  return database.transaction(() async {
    final existing =
        await (database.select(database.weight)
              ..where(
                (w) => w.loggedAt.isBiggerOrEqualValue(startOfDay(today)),
              )
              ..where(
                (w) => w.loggedAt.isSmallerThanValue(startOfNextDay(today)),
              )
              ..limit(1))
            .getSingleOrNull();

    if (existing != null) {
      await (database.update(database.weight)
            ..where((w) => w.id.equals(existing.id)))
          .write(WeightCompanion(value: Value(rounded)));
    } else {
      await database
          .into(database.weight)
          .insert(
            WeightCompanion.insert(
              value: rounded,
              loggedAt: now == null ? const Value.absent() : Value(now),
            ),
          );
    }
  });
}

/// Today's step count, or null if none has been logged today.
Future<StepsData?> findTodaysSteps(AppDatabase database, {DateTime? now}) {
  final today = now ?? DateTime.now();
  return (database.select(database.steps)
        ..where((s) => s.loggedAt.isBiggerOrEqualValue(startOfDay(today)))
        ..where((s) => s.loggedAt.isSmallerThanValue(startOfNextDay(today)))
        ..limit(1))
      .getSingleOrNull();
}

/// Saves [value] as today's step count, replacing today's entry if there is one.
Future<void> saveTodaysSteps(
  AppDatabase database,
  int value, {
  DateTime? now,
}) {
  return database.transaction(() async {
    final existing = await findTodaysSteps(database, now: now);

    if (existing != null) {
      await (database.update(database.steps)
            ..where((s) => s.id.equals(existing.id)))
          .write(StepsCompanion(value: Value(value)));
    } else {
      await database
          .into(database.steps)
          .insert(
            StepsCompanion.insert(
              value: value,
              loggedAt: now == null ? const Value.absent() : Value(now),
            ),
          );
    }
  });
}

/// Marks a session finished and stores its real duration.
///
/// The duration is measured from the session's `startedAt` as stored in the
/// database, not from any value cached in the UI.
Future<void> finishSession(
  AppDatabase database,
  int sessionId, {
  DateTime? now,
}) {
  final finishedAt = now ?? DateTime.now();

  return database.transaction(() async {
    final session = await (database.select(
      database.dailySession,
    )..where((s) => s.id.equals(sessionId))).getSingle();

    final startedAt = session.startedAt ?? finishedAt;
    final duration = finishedAt.difference(startedAt).inSeconds;

    await (database.update(
      database.dailySession,
    )..where((s) => s.id.equals(sessionId))).write(
      DailySessionCompanion(
        isFinished: const Value(true),
        startedAt: Value(startedAt),
        finishedAt: Value(finishedAt),
        workoutDurationInSeconds: Value(duration < 0 ? 0 : duration),
      ),
    );
  });
}

/// How much the weight changed over the last 7 days, or null if there is
/// nothing to compare against.
///
/// Compares the latest entry with the last entry logged before the 7-day
/// window. If nothing was logged before the window, the earliest entry inside
/// it is used instead.
Future<double?> findWeeklyWeightChange(
  AppDatabase database, {
  DateTime? now,
}) async {
  final latest = await findLatestWeight(database);
  if (latest == null) return null;

  final today = now ?? DateTime.now();
  final windowStart = startOfDay(today.subtract(const Duration(days: 6)));

  final beforeWindow =
      await (database.select(database.weight)
            ..where((w) => w.loggedAt.isSmallerThanValue(windowStart))
            ..orderBy([(w) => OrderingTerm.desc(w.loggedAt)])
            ..limit(1))
          .getSingleOrNull();

  final baseline =
      beforeWindow ??
      await (database.select(database.weight)
            ..where((w) => w.loggedAt.isBiggerOrEqualValue(windowStart))
            ..orderBy([(w) => OrderingTerm.asc(w.loggedAt)])
            ..limit(1))
          .getSingleOrNull();

  if (baseline == null || baseline.id == latest.id) return null;

  return ((latest.value - baseline.value) * 10).roundToDouble() / 10;
}

/// The most recent [count] weight entries, oldest first (for charting).
Future<List<WeightData>> findRecentWeights(
  AppDatabase database, {
  int count = 10,
}) async {
  final newestFirst =
      await (database.select(database.weight)
            ..orderBy([(w) => OrderingTerm.desc(w.loggedAt)])
            ..limit(count))
          .get();
  return newestFirst.reversed.toList();
}

/// Number of finished workouts in one week (weeks start on Monday).
class WeeklyWorkoutCount {
  final DateTime weekStart;
  final int count;

  const WeeklyWorkoutCount(this.weekStart, this.count);
}

/// Finished workouts per week for the last [weeks] weeks, oldest first.
/// The last entry is the current week.
Future<List<WeeklyWorkoutCount>> findWorkoutsPerWeek(
  AppDatabase database, {
  int weeks = 8,
  DateTime? now,
}) async {
  final today = startOfDay(now ?? DateTime.now());
  final thisWeekStart = DateTime(
    today.year,
    today.month,
    today.day - (today.weekday - 1),
  );
  final weekStarts = List.generate(
    weeks,
    (i) => DateTime(
      thisWeekStart.year,
      thisWeekStart.month,
      thisWeekStart.day - 7 * (weeks - 1 - i),
    ),
  );

  final sessions =
      await (database.select(database.dailySession)
            ..where((s) => s.isFinished.equals(true))
            ..where((s) => s.createdAt.isBiggerOrEqualValue(weekStarts.first)))
          .get();

  final counts = List.filled(weeks, 0);
  for (final session in sessions) {
    for (var i = weeks - 1; i >= 0; i--) {
      if (!session.createdAt.isBefore(weekStarts[i])) {
        counts[i]++;
        break;
      }
    }
  }

  return [
    for (var i = 0; i < weeks; i++)
      WeeklyWorkoutCount(weekStarts[i], counts[i]),
  ];
}

/// Fitness goals offered on the Profile screen.
const List<String> fitnessGoals = [
  'Lose Weight',
  'Build Muscle',
  'Maintain',
  'Improve Endurance',
];

/// The user's profile, created empty the first time it's needed.
Future<UserProfileData> getProfile(AppDatabase database) {
  return database.transaction(() async {
    final existing =
        await (database.select(database.userProfile)
              ..orderBy([(p) => OrderingTerm.asc(p.id)])
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing;

    final id = await database
        .into(database.userProfile)
        .insert(const UserProfileCompanion());
    return (database.select(
      database.userProfile,
    )..where((p) => p.id.equals(id))).getSingle();
  });
}

/// Saves the given profile fields; fields left absent are unchanged.
Future<void> updateProfile(AppDatabase database, UserProfileCompanion changes) {
  return database.transaction(() async {
    final profile = await getProfile(database);
    await (database.update(
      database.userProfile,
    )..where((p) => p.id.equals(profile.id))).write(changes);
  });
}

/// When the user started: the earliest of the profile, any workout session
/// and any weight entry.
Future<DateTime> findMemberSince(AppDatabase database) async {
  final profile = await getProfile(database);

  final firstSession =
      await (database.select(database.dailySession)
            ..orderBy([(s) => OrderingTerm.asc(s.createdAt)])
            ..limit(1))
          .getSingleOrNull();
  final firstWeight =
      await (database.select(database.weight)
            ..orderBy([(w) => OrderingTerm.asc(w.loggedAt)])
            ..limit(1))
          .getSingleOrNull();

  return [
    profile.createdAt,
    ?firstSession?.createdAt,
    ?firstWeight?.loggedAt,
  ].reduce((a, b) => a.isBefore(b) ? a : b);
}

/// How many workouts a week the Home screen counts towards.
const int weeklyWorkoutGoal = 4;

/// Finished workouts so far this week (from Monday), and the current daily
/// streak.
class WorkoutProgress {
  final int workoutsThisWeek;

  /// Consecutive days with a finished workout, ending today. If today has no
  /// workout yet, the streak counts back from yesterday, so it isn't lost
  /// until the day is over.
  final int streakDays;

  const WorkoutProgress({
    required this.workoutsThisWeek,
    required this.streakDays,
  });
}

Future<WorkoutProgress> findWorkoutProgress(
  AppDatabase database, {
  DateTime? now,
}) async {
  final today = startOfDay(now ?? DateTime.now());
  final thisWeek = await findWorkoutsPerWeek(database, weeks: 1, now: today);

  final finished =
      await (database.select(database.dailySession)
            ..where((s) => s.isFinished.equals(true))
            ..where(
              (s) => s.createdAt.isSmallerThanValue(startOfNextDay(today)),
            ))
          .get();
  final workoutDays = finished.map((s) => startOfDay(s.createdAt)).toSet();

  var day = workoutDays.contains(today)
      ? today
      : DateTime(today.year, today.month, today.day - 1);
  var streak = 0;
  while (workoutDays.contains(day)) {
    streak++;
    day = DateTime(day.year, day.month, day.day - 1);
  }

  return WorkoutProgress(
    workoutsThisWeek: thisWeek.single.count,
    streakDays: streak,
  );
}
