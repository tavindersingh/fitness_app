import 'package:dotted_border/dotted_border.dart';
import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/select_exercise_screen.dart';
import 'package:flutter/material.dart';

class CurrentWorkoutScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<CurrentWorkoutScreen> createState() => _CurrentWorkoutScreenState();
}

class _CurrentWorkoutScreenState extends State<CurrentWorkoutScreen> {
  List<Workout> workoutList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF0b0d0f),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: workoutList.length,
                itemBuilder: (context, index) {
                  Workout workout = workoutList[index];

                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.exercise.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      dashPattern: [20, 5],
                      color: Colors.grey,
                      radius: Radius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        List<Exercise>? selectedExercisesList =
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SelectExerciseScreen(),
                              ),
                            );

                        if (selectedExercisesList != null) {
                          for (Exercise exercise in selectedExercisesList) {
                            Workout workout = Workout(exercise: exercise);
                            workoutList.add(workout);
                          }

                          setState(() {});
                        }

                        print(selectedExercisesList);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Center(
                          child: Text(
                            '+ Add Exercise',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
