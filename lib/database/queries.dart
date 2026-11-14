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
Future<Step?> findTodaysSteps(AppDatabase database, {DateTime? now}) {
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
