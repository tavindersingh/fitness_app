import 'package:flutter/material.dart';

/// Progress towards the weekly workout goal, plus the current daily streak.
class WeeklyProgressCard extends StatelessWidget {
  final int workoutsThisWeek;
  final int weeklyGoal;
  final int streakDays;

  const WeeklyProgressCard({
    super.key,
    required this.workoutsThisWeek,
    required this.weeklyGoal,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (workoutsThisWeek / weeklyGoal).clamp(0.0, 1.0);
    final percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15181C),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 16,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    color: Colors.indigoAccent,
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.08),
                  ),
                ),
                Text(
                  "$percent%",
                  style: const TextStyle(
                    color: Color(0xFFF5F6F7),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  _workoutsText(),
                  style: const TextStyle(
                    color: Color(0xFFF5F6F7),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _streakText(),
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _workoutsText() {
    final noun = weeklyGoal == 1 ? "workout" : "workouts";
    return "$workoutsThisWeek of $weeklyGoal $noun this week";
  }

  String _streakText() {
    if (streakDays == 0) return "Finish a workout to start a streak";
    if (workoutsThisWeek >= weeklyGoal) {
      return "$streakDays day streak · weekly goal reached";
    }
    return "$streakDays day streak · keep it up";
  }
}
