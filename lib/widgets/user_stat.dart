import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const int dailyStepsGoal = 10000;

const _cardColor = Color(0xFF15181C);
const _textColor = Color(0xFFF5F6F7);
const _mutedColor = Color.fromRGBO(255, 255, 255, 0.4);
const _weightColor = Color(0xFF7B93F0);
const _stepsColor = Color(0xFF3DBE8E);

/// Today's weight and steps, shown side by side on the Home screen.
class UserStat extends StatelessWidget {
  /// Latest logged weight in kg, or null if none has been logged.
  final double? weight;

  /// Change in weight over the last 7 days, or null if unknown.
  final double? weeklyWeightChange;

  /// Steps logged today, or null if none have been logged.
  final int? steps;

  const UserStat({
    super.key,
    this.weight,
    this.weeklyWeightChange,
    this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Expanded(child: _weightCard()),
          Expanded(child: _stepsCard()),
        ],
      ),
    );
  }

  Widget _weightCard() {
    final change = weeklyWeightChange;

    String changeText;
    Color changeColor = _mutedColor;
    IconData? changeIcon;
    if (change == null) {
      changeText = weight == null ? "Not logged yet" : "No change data yet";
    } else if (change == 0) {
      changeText = "No change this week";
    } else {
      changeIcon = change < 0
          ? Icons.arrow_downward_rounded
          : Icons.arrow_upward_rounded;
      changeText = "${change.abs().toStringAsFixed(1)} kg this week";
      if (change < 0) changeColor = _stepsColor;
    }

    return _StatCard(
      icon: Icons.monitor_weight_outlined,
      iconColor: _weightColor,
      label: "Weight",
      value: weight == null ? "--" : "${weight!.toStringAsFixed(1)} kg",
      footer: Row(
        spacing: 2,
        children: [
          if (changeIcon != null)
            Icon(changeIcon, size: 12, color: changeColor),
          Flexible(
            child: Text(
              changeText,
              style: TextStyle(
                color: changeColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepsCard() {
    final todaySteps = steps ?? 0;
    final progress = (todaySteps / dailyStepsGoal).clamp(0.0, 1.0);
    final format = NumberFormat.decimalPattern();

    return _StatCard(
      icon: Icons.directions_walk_rounded,
      iconColor: _stepsColor,
      label: "Steps",
      value: format.format(todaySteps),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              color: _stepsColor,
              backgroundColor: const Color.fromRGBO(255, 255, 255, 0.08),
            ),
          ),
          Text(
            "of ${format.format(dailyStepsGoal)}",
            style: const TextStyle(
              color: _mutedColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Widget footer;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: _mutedColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _textColor,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          footer,
        ],
      ),
    );
  }
}
