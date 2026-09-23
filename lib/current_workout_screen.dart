import 'package:dotted_border/dotted_border.dart';
import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/select_exercise_screen.dart';
import 'package:fitness_app/widgets/app_button.dart';
import 'package:fitness_app/widgets/app_checkbox.dart';
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
                itemCount: workoutList.length + 1,
                itemBuilder: (context, index) {
                  if (index == workoutList.length) {
                    return addExerciseButton();
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
                          onClick: (value) {
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

  Widget addExerciseButton() {
    return GestureDetector(
      onTap: () async {
        List<Exercise>? selectedExercisesList = await Navigator.of(context)
            .push(
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
      child: Row(
        children: [
          Expanded(
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: [20, 5],
                color: Colors.grey,
                radius: Radius.circular(16),
              ),
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
        ],
      ),
    );
  }
}
