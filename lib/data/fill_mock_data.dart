import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';

Future<void> fillMockSessionsData() async {
  final databaseProvider = DatabaseProvider();
  final database = databaseProvider.database;

  PlanData? planData = await database.select(database.plan).getSingleOrNull();

  if (planData == null) {
    print("No Plan data found");
    return;
  }

  List<WorkoutExerciseData> workoutExerciseDataList = await (database.select(
    database.workoutExercise,
  )..where((item) => item.planId.equals(planData.id))).get();

  int totalPastDates = 10;

  for (int i = 0; i < totalPastDates; i++) {
    DateTime sessionDate = DateTime.now().subtract(
      Duration(
        days: i + 1,
      ),
    );

    int workoutDuration = Random().nextInt(600) + 600;

    int dailySessionId = await database
        .into(database.dailySession)
        .insert(
          DailySessionCompanion(
            planId: Value(planData.id),
            isFinished: Value(true),
            createdAt: Value(sessionDate),
            startedAt: Value(sessionDate),
            finishedAt: Value(
              sessionDate.add(Duration(seconds: workoutDuration)),
            ),
            workoutDurationInSeconds: Value(workoutDuration),
          ),
        );

    for (WorkoutExerciseData workoutExerciseData in workoutExerciseDataList) {
      await database
          .into(database.sessionExerciseStatus)
          .insert(
            SessionExerciseStatusCompanion(
              createdAt: Value(sessionDate),
              dailySessionId: Value(dailySessionId),
              exerciseId: Value(workoutExerciseData.exerciseId),
              isFinished: Value(Random().nextBool()),
            ),
          );
    }
  }
}
