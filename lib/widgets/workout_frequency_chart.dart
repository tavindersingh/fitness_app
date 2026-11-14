import 'dart:math' as math;

import 'package:fitness_app/database/queries.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Bar chart of finished workouts per week; the current week is highlighted.
class WorkoutFrequencyChart extends StatelessWidget {
  final List<WeeklyWorkoutCount> weeks;

  const WorkoutFrequencyChart({super.key, required this.weeks});

  @override
  Widget build(BuildContext context) {
    final maxCount = weeks.map((w) => w.count).reduce(math.max);
    final dateFormat = DateFormat('d MMM');

    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          // Headroom for the count labels drawn above each bar.
          maxY: math.max(1, maxCount) * 1.25,
          minY: 0,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    dateFormat.format(weeks[value.toInt()].weekStart),
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.35),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 2,
              getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                  BarTooltipItem(
                    rod.toY.toInt().toString(),
                    const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            ),
          ),
          barGroups: [
            for (final (index, week) in weeks.indexed)
              BarChartGroupData(
                x: index,
                // Always show the count above each bar.
                showingTooltipIndicators: [0],
                barRods: [
                  BarChartRodData(
                    toY: week.count.toDouble(),
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                    color: index == weeks.length - 1
                        ? Colors.indigoAccent
                        : const Color.fromRGBO(255, 255, 255, 0.22),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
