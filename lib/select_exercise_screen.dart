import 'package:fitness_app/data/exercise_list.dart';
import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/widgets/select_exercise_list_item.dart';
import 'package:flutter/material.dart';

class SelectExerciseScreen extends StatefulWidget {
  const SelectExerciseScreen({super.key});

  @override
  State<SelectExerciseScreen> createState() => _SelectExerciseScreenState();
}

class _SelectExerciseScreenState extends State<SelectExerciseScreen> {
  String selectedType = "All";
  List<Exercise> filteredExerciseList = [];

  List<int> selectedExerciseIds = [];

  @override
  void initState() {
    filteredExerciseList.addAll(exercisesList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        backgroundColor: Color(0xFF0b0d0f),
        title: Text(
          "Select Exercise",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 34,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: bodyParts.length,
              itemBuilder: (context, index) {
                String currentBodyPart = bodyParts[index];
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      setState(() {
                        selectedType = currentBodyPart;

                        filteredExerciseList.clear();

                        if (selectedType == 'All') {
                          filteredExerciseList.addAll(exercisesList);
                        } else {
                          filteredExerciseList.addAll(
                            exercisesList.where(
                              (item) => item.bodyPart == selectedType,
                            ),
                          );
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedType == currentBodyPart
                            ? Colors.indigoAccent.withAlpha(60)
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedType == currentBodyPart
                              ? Colors.indigoAccent
                              : Color(0xFF272a2e),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Text(
                        currentBodyPart,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedType == currentBodyPart
                              ? Colors.indigoAccent
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredExerciseList.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredExerciseList.length,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (context, index) {
                      return SelectExerciseListItem(
                        exercise: filteredExerciseList[index],
                        onExerciseSelected: (int id) {
                          // logic to update UI
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No Exercise Found",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
