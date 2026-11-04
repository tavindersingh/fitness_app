import 'package:fitness_app/data/exercise_list.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';

class SessionHistoryDetailDialog extends StatelessWidget {
  final DailySessionData dailySession;
  final PlanData planData;
  final List<SessionExerciseStatusData> sessionExercisesList;

  const new({
    super.key,
    required this.dailySession,
    required this.planData,
    required this.sessionExercisesList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      color: Color(0xFF0b0d0f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planData.name,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...fetchExercisesList(sessionExercisesList).map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  AppCheckbox(
                    onClick: (value) {},
                    isSelected: item['isFinished'],
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  Text(
                    item['exercise'].name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map> fetchExercisesList(
    List<SessionExerciseStatusData> sessionExercisesList,
  ) {
    List<Map> exerciseData = [];
    // exercise name
    // isFinished
    for (SessionExerciseStatusData item in sessionExercisesList) {
      int exeriseId = item.exerciseId;

      final exercise = exercisesList.firstWhere((e) => e.id == exeriseId);
      final isFinished = item.isFinished;

      exerciseData.add({
        "exercise": exercise,
        "isFinished": isFinished,
      });
    }

    return exerciseData;
  }
}
