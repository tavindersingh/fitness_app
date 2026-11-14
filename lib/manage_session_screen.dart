import 'package:fitness_app/data/exercise_list.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/widgets/select_exercise_list_item.dart';
import 'package:flutter/material.dart';

class ManageSessionScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ManageSessionScreen> createState() => _ManageSessionScreenState();
}

class _ManageSessionScreenState extends State<ManageSessionScreen> {
  String selectedType = "All";
  List<Exercise> filteredExerciseList = [];

  List<int> selectedExerciseIds = [];

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    filteredExerciseList.addAll(exercisesList);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Returns an error message, or null if the plan can be saved.
  String? validatePlan(String name, List<int> exerciseIds) {
    if (name.isEmpty) return "Please enter a session name.";
    if (name.length > 32) return "Session name must be 32 characters or fewer.";
    if (exerciseIds.isEmpty) return "Please select at least one exercise.";
    return null;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF0b0d0f),
        title: Text(
          "Manage Session",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              final error = validatePlan(name, selectedExerciseIds);

              if (error != null) {
                showError(error);
                return;
              }

              try {
                await storePlanDetails(
                  name,
                  selectedExerciseIds,
                );
              } catch (e) {
                showError("Couldn't save the session. Please try again.");
                return;
              }

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.check_rounded),
            tooltip: "Save Session",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              maxLength: 32,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Session Name",
              ),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 34,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
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
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: filteredExerciseList.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredExerciseList.length,
                      // padding: const EdgeInsets.all(20),
                      itemBuilder: (context, index) {
                        return SelectExerciseListItem(
                          exercise: filteredExerciseList[index],
                          isSelected: isExerciseSelected(
                            filteredExerciseList[index].id,
                          ),
                          onExerciseSelected: (int id) {
                            setState(() {
                              if (isExerciseSelected(id)) {
                                return;
                              }

                              selectedExerciseIds.add(id);
                            });
                          },
                          onExerciseUnselected: (int id) {
                            setState(() {
                              selectedExerciseIds = selectedExerciseIds
                                  .where(
                                    (item) => item != id,
                                  )
                                  .toList();
                            });
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
      ),
    );
  }

  bool isExerciseSelected(int id) {
    // search
    for (int i = 0; i < selectedExerciseIds.length; i++) {
      if (id == selectedExerciseIds[i]) {
        return true;
      }
    }

    return false;
  }

  Future<void> storePlanDetails(
    String name,
    List<int> selectedExerciseIds,
  ) async {
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    await database.transaction(() async {
      int planId = await database
          .into(database.plan)
          .insert(
            PlanCompanion.insert(name: name),
          );

      for (int id in selectedExerciseIds) {
        await database
            .into(database.workoutExercise)
            .insert(
              WorkoutExerciseCompanion.insert(
                exerciseId: id,
                planId: planId,
              ),
            );
      }
    });
  }
}
