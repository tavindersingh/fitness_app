import 'dart:async';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/manage_session_screen.dart';
import 'package:flutter/material.dart';

class SelectSessionScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SelectSessionScreen> createState() => _SelectSessionScreenState();
}

class _SelectSessionScreenState extends State<SelectSessionScreen> {
  late StreamController<List<PlanData>> _plansController;

  @override
  void initState() {
    _plansController = StreamController<List<PlanData>>();

    fetchExercisePlans();

    super.initState();
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
          "Select Session",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ManageSessionScreen()),
          );

          fetchExercisePlans();
        },
      ),
      body: StreamBuilder(
        stream: _plansController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              PlanData planData = (snapshot.data as List<PlanData>)[index];

              return GestureDetector(
                onTap: () async {
                  await saveSelectedPlan(planData);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF15181c),
                    border: Border.all(
                      color: Color(0xFF272a2e),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    planData.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> saveSelectedPlan(PlanData planData) async {
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    List<WorkoutExerciseData> filteredWorkoutList = await (database.select(
      database.workoutExercise,
    )..where((workout) => workout.planId.equals(planData.id))).get();

    final dailySessionId = await database
        .into(database.dailySession)
        .insert(DailySessionCompanion.insert(planId: planData.id));

    for (var workout in filteredWorkoutList) {
      await database
          .into(database.sessionExerciseStatus)
          .insert(
            SessionExerciseStatusCompanion.insert(
              dailySessionId: dailySessionId,
              exerciseId: workout.exerciseId,
            ),
          );
    }
  }

  Future<void> fetchExercisePlans() async {
    final databaseProvider = DatabaseProvider();
    final database = databaseProvider.database;

    List<PlanData> plansList = await database.select(database.plan).get();

    _plansController.sink.add(plansList);
  }
}
