import 'package:drift/drift.dart' hide Column;
import 'package:fitness_app/data/exercise_list.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/widgets/app_button.dart';
import 'package:fitness_app/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';

class CurrentWorkoutScreen extends StatefulWidget {
  final PlanData planData;
  final DailySessionData dailySessionData;
  final List<SessionExerciseStatusData> sessionExerciseStatusDataList;

  const new({
    super.key,
    required this.planData,
    required this.dailySessionData,
    required this.sessionExerciseStatusDataList,
  });

  @override
  State<CurrentWorkoutScreen> createState() => _CurrentWorkoutScreenState();
}

class _CurrentWorkoutScreenState extends State<CurrentWorkoutScreen> {
  List<Workout> workoutList = [];

  Future<void> _fetchExercisesList(int planId) async {
    // List<WorkoutExerciseData> filteredWorkoutList = await (database.select(
    //   database.workoutExercise,
    // )..where((workout) => workout.planId.equals(planId))).get();

    for (var exerciseStatus in widget.sessionExerciseStatusDataList) {
      int exerciseId = exerciseStatus.exerciseId;

      List<Exercise> filteredExercisesList = exercisesList
          .where(
            (item) => item.id == exerciseId,
          )
          .toList();

      for (var item in filteredExercisesList) {
        workoutList.add(
          Workout(
            exercise: item,
            isCompleted: exerciseStatus.isFinished,
          ),
        );
      }
    }

    setState(() {});
  }

  Future<void> toggleExerciseStatus(int exerciseId, bool isFinished) async {
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    await (database.update(
            database.sessionExerciseStatus,
          )
          ..where(
            (status) =>
                status.dailySessionId.equals(widget.dailySessionData.id),
          )
          ..where((status) => status.exerciseId.equals(exerciseId)))
        .write(
          SessionExerciseStatusCompanion(
            isFinished: Value(isFinished),
          ),
        );
  }

  @override
  void initState() {
    super.initState();

    _fetchExercisesList(widget.dailySessionData.planId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF0b0d0f),
        title: Text(widget.planData.name),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: workoutList.length + 1,
                itemBuilder: (context, index) {
                  if (index == workoutList.length) {
                    // return addExerciseButton();

                    return const SizedBox();
                  }
                  Workout workout = workoutList[index];

                  return Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF15181c),
                      border: Border.all(
                        color: Color(0xFF272a2e),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCheckbox(
                          isSelected: workout.isCompleted,
                          onClick: (value) async {
                            await toggleExerciseStatus(
                              workoutList[index].exercise.id,
                              value,
                            );
                            setState(() {
                              workoutList[index].isCompleted = value;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          workout.exercise.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            AppButton(
              label: "Finish Session",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
