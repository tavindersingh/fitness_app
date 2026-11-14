import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  // The migration test opens a second, separate in-memory database.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<int> createPlan(List<int> exerciseIds, {String name = 'Legs'}) async {
    final planId = await db
        .into(db.plan)
        .insert(PlanCompanion.insert(name: name));
    for (final id in exerciseIds) {
      await db
          .into(db.workoutExercise)
          .insert(
            WorkoutExerciseCompanion.insert(exerciseId: id, planId: planId),
          );
    }
    return planId;
  }

  test('plan names shorter than 6 characters can be saved', () async {
    final planId = await createPlan([1], name: 'Legs');
    expect(planId, greaterThan(0));
  });

  group('weight', () {
    test('latest weight works with several days of entries', () async {
      await saveTodaysWeight(db, 70, now: DateTime(2026, 11, 12, 9));
      await saveTodaysWeight(db, 71, now: DateTime(2026, 11, 13, 9));
      await saveTodaysWeight(db, 72, now: DateTime(2026, 11, 14, 9));

      final latest = await findLatestWeight(db);
      expect(latest!.value, 72);
    });

    test('saving twice on the same day updates the entry', () async {
      await saveTodaysWeight(db, 70, now: DateTime(2026, 11, 14, 8));
      await saveTodaysWeight(db, 70.3, now: DateTime(2026, 11, 14, 20));

      final rows = await db.select(db.weight).get();
      expect(rows, hasLength(1));
      expect(rows.single.value, 70.3);
    });

    test('values are rounded to one decimal', () async {
      var value = 70.0;
      for (var i = 0; i < 3; i++) {
        value += 0.1;
      }
      await saveTodaysWeight(db, value, now: DateTime(2026, 11, 14));

      final latest = await findLatestWeight(db);
      expect(latest!.value, 70.3);
    });
  });

  group('steps', () {
    test('saving updates today and keeps other days', () async {
      await saveTodaysSteps(db, 4000, now: DateTime(2026, 11, 13, 21));
      await saveTodaysSteps(db, 1000, now: DateTime(2026, 11, 14, 8));
      await saveTodaysSteps(db, 2500, now: DateTime(2026, 11, 14, 18));

      final today = await findTodaysSteps(db, now: DateTime(2026, 11, 14, 23));
      expect(today!.value, 2500);
      expect(await db.select(db.steps).get(), hasLength(2));
    });
  });

  group('daily session', () {
    test('starting twice on the same day creates one session', () async {
      final planId = await createPlan([1, 2]);
      final now = DateTime(2026, 11, 14, 7);

      final results = await Future.wait([
        startTodaysSession(db, planId, now: now),
        startTodaysSession(db, planId, now: now),
      ]);

      expect(results[0], results[1]);
      expect(await db.select(db.dailySession).get(), hasLength(1));
      expect(await db.select(db.sessionExerciseStatus).get(), hasLength(2));
    });

    test('an early-morning session is found as today (local time)', () async {
      final planId = await createPlan([1]);
      // 00:30 local time is still "yesterday" in UTC for timezones east of
      // UTC, which the old DATE(..., 'unixepoch') comparison got wrong.
      await startTodaysSession(db, planId, now: DateTime(2026, 11, 14, 0, 30));

      final found = await findTodaysSession(
        db,
        now: DateTime(2026, 11, 14, 12),
      );
      expect(found, isNotNull);

      final yesterday = await findTodaysSession(
        db,
        now: DateTime(2026, 11, 13, 12),
      );
      expect(yesterday, isNull);
    });

    test('finishing stores the real duration', () async {
      final planId = await createPlan([1]);
      final sessionId = await startTodaysSession(db, planId);
      final startedAt = DateTime(2026, 11, 14, 7);

      await (db.update(db.dailySession)..where((s) => s.id.equals(sessionId)))
          .write(DailySessionCompanion(startedAt: Value(startedAt)));

      await finishSession(
        db,
        sessionId,
        now: startedAt.add(const Duration(minutes: 42, seconds: 5)),
      );

      final session = await (db.select(
        db.dailySession,
      )..where((s) => s.id.equals(sessionId))).getSingle();
      expect(session.isFinished, isTrue);
      expect(session.workoutDurationInSeconds, 42 * 60 + 5);
    });
  });

  test('foreign keys are enforced', () async {
    await expectLater(
      db
          .into(db.dailySession)
          .insert(DailySessionCompanion.insert(planId: 999)),
      throwsA(isA<SqliteException>()),
    );
  });

  test(
    'upgrading a version 3 database adds missing tables and columns',
    () async {
      final old = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (raw) {
            // A version-3 install from before weight/steps and
            // workoutDurationInSeconds existed.
            raw.execute('''
            CREATE TABLE plan (id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL);
            CREATE TABLE workout_exercise (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              exercise_id INTEGER NOT NULL, plan_id INTEGER NOT NULL);
            CREATE TABLE daily_session (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              plan_id INTEGER NOT NULL,
              is_finished INTEGER NOT NULL DEFAULT 0,
              started_at INTEGER NULL, finished_at INTEGER NULL,
              created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')));
            CREATE TABLE session_exercise_status (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              daily_session_id INTEGER NOT NULL,
              exercise_id INTEGER NOT NULL,
              is_finished INTEGER NOT NULL DEFAULT 0,
              created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')));
            PRAGMA user_version = 3;
          ''');
          },
        ),
      );
      addTearDown(old.close);

      await saveTodaysWeight(old, 70);
      await saveTodaysSteps(old, 1000);
      final planId = await (old.into(
        old.plan,
      )).insert(PlanCompanion.insert(name: 'Push'));
      final sessionId = await startTodaysSession(old, planId);
      await finishSession(old, sessionId);
      await updateProfile(old, const UserProfileCompanion(name: Value('Sam')));

      expect(await findLatestWeight(old), isNotNull);
      expect((await getProfile(old)).name, 'Sam');
    },
  );

  group('progress', () {
    test(
      'weekly weight change compares with last entry before the week',
      () async {
        await saveTodaysWeight(db, 80.0, now: DateTime(2026, 11, 1, 9));
        await saveTodaysWeight(db, 79.6, now: DateTime(2026, 11, 10, 9));
        await saveTodaysWeight(db, 79.4, now: DateTime(2026, 11, 14, 9));

        final change = await findWeeklyWeightChange(
          db,
          now: DateTime(2026, 11, 14, 12),
        );
        expect(change, -0.6);
      },
    );

    test('weekly weight change is null with a single entry', () async {
      await saveTodaysWeight(db, 80.0, now: DateTime(2026, 11, 14, 9));
      expect(
        await findWeeklyWeightChange(db, now: DateTime(2026, 11, 14, 12)),
        isNull,
      );
    });

    test('recent weights are the newest ones, oldest first', () async {
      for (var day = 1; day <= 12; day++) {
        await saveTodaysWeight(
          db,
          80.0 - day / 10,
          now: DateTime(2026, 11, day, 9),
        );
      }

      final recent = await findRecentWeights(db, count: 10);
      expect(recent, hasLength(10));
      expect(recent.first.loggedAt, DateTime(2026, 11, 3, 9));
      expect(recent.last.loggedAt, DateTime(2026, 11, 12, 9));
    });

    test('workouts per week counts finished sessions by Monday week', () async {
      final planId = await createPlan([1]);
      Future<void> addSession(DateTime createdAt, {bool finished = true}) => db
          .into(db.dailySession)
          .insert(
            DailySessionCompanion.insert(
              planId: planId,
              createdAt: Value(createdAt),
              isFinished: Value(finished),
            ),
          );

      // Saturday 14 Nov 2026; this week starts Monday 9 Nov.
      final now = DateTime(2026, 11, 14, 12);
      await addSession(DateTime(2026, 11, 9, 7));
      await addSession(DateTime(2026, 11, 13, 7));
      await addSession(DateTime(2026, 11, 14, 7), finished: false);
      await addSession(DateTime(2026, 11, 8, 7)); // Sunday, previous week
      await addSession(DateTime(2026, 9, 1, 7)); // too old

      final weeks = await findWorkoutsPerWeek(db, weeks: 8, now: now);
      expect(weeks, hasLength(8));
      expect(weeks.last.weekStart, DateTime(2026, 11, 9));
      expect(weeks.last.count, 2);
      expect(weeks[6].count, 1);
      expect(weeks.take(6).every((w) => w.count == 0), isTrue);
    });
  });

  group('profile', () {
    test('getProfile creates one empty profile and reuses it', () async {
      final first = await getProfile(db);
      final second = await getProfile(db);

      expect(first.id, second.id);
      expect(first.name, isNull);
      expect(await db.select(db.userProfile).get(), hasLength(1));
    });

    test('updateProfile changes only the given fields', () async {
      await updateProfile(db, const UserProfileCompanion(name: Value('Sam')));
      await updateProfile(
        db,
        const UserProfileCompanion(age: Value(29), heightCm: Value(178)),
      );
      await updateProfile(
        db,
        UserProfileCompanion(goal: Value(fitnessGoals[1])),
      );

      final profile = await getProfile(db);
      expect(profile.name, 'Sam');
      expect(profile.age, 29);
      expect(profile.heightCm, 178);
      expect(profile.goal, 'Build Muscle');
      expect(await db.select(db.userProfile).get(), hasLength(1));
    });

    test('member since is the earliest activity', () async {
      await saveTodaysWeight(db, 80, now: DateTime(2025, 3, 10, 8));
      final planId = await createPlan([1]);
      await startTodaysSession(db, planId, now: DateTime(2025, 1, 20, 7));

      expect(await findMemberSince(db), DateTime(2025, 1, 20, 7));
    });
  });

  group('workout progress', () {
    late int planId;
    // Saturday 14 Nov 2026; the week started Monday 9 Nov.
    final now = DateTime(2026, 11, 14, 12);

    Future<void> addSession(DateTime createdAt, {bool finished = true}) => db
        .into(db.dailySession)
        .insert(
          DailySessionCompanion.insert(
            planId: planId,
            createdAt: Value(createdAt),
            isFinished: Value(finished),
          ),
        );

    setUp(() async {
      planId = await createPlan([1]);
    });

    test('no workouts means zero progress and no streak', () async {
      final progress = await findWorkoutProgress(db, now: now);
      expect(progress.workoutsThisWeek, 0);
      expect(progress.streakDays, 0);
    });

    test('counts finished workouts this week and the streak', () async {
      await addSession(DateTime(2026, 11, 8, 7)); // Sunday, last week
      await addSession(DateTime(2026, 11, 9, 7)); // Monday
      await addSession(DateTime(2026, 11, 10, 7)); // Tuesday
      await addSession(DateTime(2026, 11, 12, 7)); // Thursday, gap on Wed
      await addSession(DateTime(2026, 11, 13, 7)); // Friday
      await addSession(DateTime(2026, 11, 14, 7)); // today
      await addSession(DateTime(2026, 11, 11, 7), finished: false);

      final progress = await findWorkoutProgress(db, now: now);
      expect(progress.workoutsThisWeek, 5);
      expect(progress.streakDays, 3); // Thu, Fri, Sat
    });

    test('streak is kept until today is over', () async {
      await addSession(DateTime(2026, 11, 12, 7));
      await addSession(DateTime(2026, 11, 13, 7));

      final progress = await findWorkoutProgress(db, now: now);
      expect(progress.streakDays, 2);
    });

    test('streak resets after a missed day', () async {
      await addSession(DateTime(2026, 11, 11, 7));
      await addSession(DateTime(2026, 11, 12, 7));

      final progress = await findWorkoutProgress(db, now: now);
      expect(progress.streakDays, 0);
      expect(progress.workoutsThisWeek, 2);
    });

    test('streak continues across the start of the week', () async {
      await addSession(DateTime(2026, 11, 8, 7)); // Sunday
      await addSession(DateTime(2026, 11, 9, 7)); // Monday

      final progress = await findWorkoutProgress(
        db,
        now: DateTime(2026, 11, 9, 20),
      );
      expect(progress.workoutsThisWeek, 1);
      expect(progress.streakDays, 2);
    });
  });
}
