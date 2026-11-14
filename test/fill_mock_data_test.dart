import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:fitness_app/data/fill_mock_data.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late File marker;
  // Saturday 14 Nov 2026.
  final now = DateTime(2026, 11, 14, 12);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('mock_data_test');
    marker = File('${tempDir.path}/mock_data_seeded');
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<void> seed() => fillMockSessionsData(
    database: db,
    markerFile: marker,
    now: now,
    random: Random(42),
  );

  test('seeds weights and workouts for the progress charts', () async {
    await seed();

    expect(marker.existsSync(), isTrue);

    final weights = await db.select(db.weight).get();
    expect(weights.length, greaterThan(10));
    expect(
      weights.every((w) => w.loggedAt.isBefore(startOfDay(now))),
      isTrue,
      reason: 'today is left for the user to log',
    );

    final weeks = await findWorkoutsPerWeek(db, weeks: 8, now: now);
    // Every past week gets 2–4 workouts; the current week has only 5 past days.
    for (final week in weeks.take(7)) {
      expect(week.count, inInclusiveRange(2, 4));
    }
    expect(weeks.last.count, inInclusiveRange(2, 4));

    expect(
      await findTodaysSession(db, now: now),
      isNull,
      reason: "today's session is left for the user to start",
    );

    final plans = await db.select(db.plan).get();
    expect(plans.map((p) => p.name), unorderedEquals(mockPlans.keys));

    // Each plan gets sessions, each with that plan's exercises.
    final sessions = await db.select(db.dailySession).get();
    for (final plan in plans) {
      final planSessions = sessions.where((s) => s.planId == plan.id);
      expect(planSessions, isNotEmpty, reason: plan.name);

      final statuses = await (db.select(
        db.sessionExerciseStatus,
      )..where((s) => s.dailySessionId.equals(planSessions.first.id))).get();
      expect(
        statuses.map((s) => s.exerciseId),
        unorderedEquals(mockPlans[plan.name]!),
      );
    }
  });

  test('runs only once', () async {
    await seed();
    final sessions = (await db.select(db.dailySession).get()).length;
    final weights = (await db.select(db.weight).get()).length;

    await seed();

    expect(await db.select(db.dailySession).get(), hasLength(sessions));
    expect(await db.select(db.weight).get(), hasLength(weights));
  });

  test('keeps existing plans and spreads sessions across all plans', () async {
    final planId = await db
        .into(db.plan)
        .insert(PlanCompanion.insert(name: 'Core Workout'));
    // An existing plan with a mock plan's name isn't duplicated.
    await db.into(db.plan).insert(PlanCompanion.insert(name: 'Leg Day'));

    await seed();

    final plans = await db.select(db.plan).get();
    expect(
      plans.map((p) => p.name),
      unorderedEquals(['Core Workout', 'Leg Day', 'Chest & Back']),
    );

    final sessions = await db.select(db.dailySession).get();
    expect(sessions.where((s) => s.planId == planId), isNotEmpty);
    expect(sessions.map((s) => s.planId).toSet(), hasLength(3));
  });
}
