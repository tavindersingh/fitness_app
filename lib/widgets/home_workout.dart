import 'package:fitness_app/current_workout_screen.dart';
import 'package:fitness_app/database/database.dart';
import 'package:flutter/material.dart';

class HomeWorkout extends StatelessWidget {
  final PlanData planData;
  final DailySessionData dailySessionData;
  final List<SessionExerciseStatusData> sessionExerciseStatusDataList;
  final VoidCallback updateStatusFromDatabase;

  const HomeWorkout({
    super.key,
    required this.planData,
    required this.dailySessionData,
    required this.sessionExerciseStatusDataList,
    required this.updateStatusFromDatabase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.sports_gymnastics_outlined, color: Colors.white),
              // SizedBox(width: 8),
              Text(
                "Today's Workout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          Text(
            planData.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Row(
            spacing: 4,
            children: [
              Text(
                "${sessionExerciseStatusDataList.length} exercises",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text("·", style: TextStyle(color: Colors.white, fontSize: 16)),
              Text(
                "~45 min",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),

          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CurrentWorkoutScreen(
                    planData: planData,
                    dailySessionData: dailySessionData,
                    sessionExerciseStatusDataList:
                        sessionExerciseStatusDataList,
                  ),
                ),
              );

              updateStatusFromDatabase();
            },
            child: Text("Start Workout"),
          ),
        ],
      ),
    );
  }
}
