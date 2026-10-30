import 'dart:math';

import 'package:fitness_app/database/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryListItem extends StatelessWidget {
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
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 24, 28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(50),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset("assets/icons/dumbbell.png"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      planData.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      DateFormat("dd MMM").format(
                        dailySession.startedAt ?? DateTime.now(),
                      ),
                      style: TextStyle(
                        color: Colors.white.withAlpha(110),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.white.withAlpha(110),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${calculateSessionTime() ~/ 60} min",
                          style: TextStyle(
                            color: Colors.white.withAlpha(110),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${sessionExercisesList.length} exercises',
                      style: TextStyle(
                        color: Colors.white.withAlpha(110),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withAlpha(110),
            size: 24,
          ),
        ],
      ),
    );
  }

  int calculateSessionTime() {
    int totalExercises = sessionExercisesList.length; // 3
    int singleExerciseTime = 10 * 60; // 10 minutes

    int breakBetweenExercise =
        Random().nextInt(500) + 500; // 5 minutes to 10 minutes

    return totalExercises * singleExerciseTime +
        (totalExercises - 1) * breakBetweenExercise;
  }
}
