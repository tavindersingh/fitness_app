import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Number of past weeks filled with mock workout sessions.
const int mockWorkoutWeeks = 8;

/// Number of past days filled with mock weight entries.
const int mockWeightDays = 30;

/// Fills the database with mock workout sessions and weight entries, once.
///
/// After a successful run a marker file is written next to the database, and
/// later calls do nothing. Uninstalling the app (or clearing its data) removes
/// both, so the mock data is seeded again on a fresh install.
///
/// [database], [markerFile], [now] and [random] are only for tests.
Future<void> fillMockSessionsData({
  AppDatabase? database,
  File? markerFile,
  DateTime? now,
  Random? random,
}) async {
  final db = database ?? DatabaseProvider().database;
  final marker = markerFile ?? await _defaultMarkerFile();

  if (await marker.exists()) return;

  final today = startOfDay(now ?? DateTime.now());
  final rng = random ?? Random();

  await db.transaction(() async {
    final plans = await _findOrCreatePlans(db);
    await _insertMockSessions(db, plans, today, rng);
    await _insertMockWeights(db, today, rng);
  });

  await marker.create(recursive: true);
  debugPrint("Mock data seeded");
}

Future<File> _defaultMarkerFile() async {
  final folder = await getApplicationDocumentsDirectory();
  return File(p.join(folder.path, 'mock_data_seeded'));
}

/// Extra plans added by the mock data, by name and exercise ids
/// (ids from the exercise list).
const Map<String, List<int>> mockPlans = {
  'Chest & Back': [1, 3], // Bench Press, DeadLift
  'Leg Day': [2, 3], // Squats, DeadLift
};

/// Creates the [mockPlans] that don't exist yet, then returns every plan
/// with its exercises, so mock sessions are spread across all of them.
Future<Map<PlanData, List<WorkoutExerciseData>>> _findOrCreatePlans(
  AppDatabase db,
) async {
  final existingNames = (await db.select(db.plan).get())
      .map((plan) => plan.name)
      .toSet();

  for (final MapEntry(key: name, value: exerciseIds) in mockPlans.entries) {
    if (existingNames.contains(name)) continue;

    final planId = await db
        .into(db.plan)
        .insert(PlanCompanion.insert(name: name));
    for (final exerciseId in exerciseIds) {
      await db
          .into(db.workoutExercise)
          .insert(
            WorkoutExerciseCompanion.insert(
              exerciseId: exerciseId,
              planId: planId,
            ),
          );
    }
  }

  final plans = await (db.select(
    db.plan,
  )..orderBy([(p) => OrderingTerm.asc(p.id)])).get();
  return {
    for (final plan in plans)
      plan: await (db.select(
        db.workoutExercise,
      )..where((w) => w.planId.equals(plan.id))).get(),
  };
}

/// 2–4 finished workouts in each of the last [mockWorkoutWeeks] weeks,
/// on past days only, so today's session is left alone. Sessions take turns
/// across [plans] so each plan shows up in History.
Future<void> _insertMockSessions(
  AppDatabase db,
  Map<PlanData, List<WorkoutExerciseData>> plans,
  DateTime today,
  Random rng,
) async {
  final planList = plans.keys.toList();
  var sessionIndex = 0;

  final thisWeekStart = DateTime(
    today.year,
    today.month,
    today.day - (today.weekday - 1),
  );

  for (var week = 0; week < mockWorkoutWeeks; week++) {
    final weekStart = DateTime(
      thisWeekStart.year,
      thisWeekStart.month,
      thisWeekStart.day - 7 * week,
    );

    final pastDays = [
      for (var d = 0; d < 7; d++)
        DateTime(weekStart.year, weekStart.month, weekStart.day + d),
    ].where((day) => day.isBefore(today)).toList()..shuffle(rng);

    final count = min(pastDays.length, 2 + rng.nextInt(3));

    // Oldest day first, so plans rotate in date order.
    final days = pastDays.take(count).toList()..sort();

    for (final day in days) {
      final plan = planList[sessionIndex++ % planList.length];
      final exercises = plans[plan]!;

      // Morning or evening workout, 30–60 minutes long.
      final startedAt = day.add(
        Duration(hours: rng.nextBool() ? 7 : 18, minutes: rng.nextInt(60)),
      );
      final duration = 30 * 60 + rng.nextInt(30 * 60);

      final sessionId = await db
          .into(db.dailySession)
          .insert(
            DailySessionCompanion.insert(
              planId: plan.id,
              isFinished: const Value(true),
              createdAt: Value(startedAt),
              startedAt: Value(startedAt),
              finishedAt: Value(startedAt.add(Duration(seconds: duration))),
              workoutDurationInSeconds: Value(duration),
            ),
          );

      for (final exercise in exercises) {
        await db
            .into(db.sessionExerciseStatus)
            .insert(
              SessionExerciseStatusCompanion.insert(
                dailySessionId: sessionId,
                exerciseId: exercise.exerciseId,
                // Most exercises get done; a few are skipped.
                isFinished: Value(rng.nextInt(5) != 0),
                createdAt: Value(startedAt),
              ),
            );
      }
    }
  }
}

/// A slowly decreasing weight with daily noise over the last
/// [mockWeightDays] days, with some days skipped. Today is left for the user.
Future<void> _insertMockWeights(
  AppDatabase db,
  DateTime today,
  Random rng,
) async {
  var weight = 80.0;

  for (var daysAgo = mockWeightDays; daysAgo >= 1; daysAgo--) {
    weight -= 0.05 + rng.nextDouble() * 0.1;

    // Skip roughly one day in four, like a real user would.
    if (rng.nextInt(4) == 0) continue;

    final noise = (rng.nextDouble() - 0.5) * 0.6;
    final day = DateTime(today.year, today.month, today.day - daysAgo);
    final loggedAt = day.add(Duration(hours: 7, minutes: rng.nextInt(60)));

    await db
        .into(db.weight)
        .insert(
          WeightCompanion.insert(
            value: ((weight + noise) * 10).roundToDouble() / 10,
            loggedAt: Value(loggedAt),
          ),
        );
  }
}
