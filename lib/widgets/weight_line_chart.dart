import 'dart:math' as math;

import 'package:fitness_app/database/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _lineColor = Colors.indigoAccent;
const _labelStyle = TextStyle(
  color: Color.fromRGBO(255, 255, 255, 0.35),
  fontSize: 10,
  fontWeight: FontWeight.w600,
);

/// Line chart of weight entries, oldest on the left.
class WeightLineChart extends StatelessWidget {
  final List<WeightData> weights;

  const WeightLineChart({super.key, required this.weights});

  @override
  Widget build(BuildContext context) {
    final values = weights.map((w) => w.value).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    // Leave some room above and below so the line and dots aren't clipped.
    final padding = math.max(0.5, (maxValue - minValue) * 0.2);
    final dateFormat = DateFormat('d MMM');

    return SizedBox(
      height: 130,
      child: LineChart(
        LineChartData(
          // A single entry is centred rather than pinned to the left edge.
          minX: weights.length == 1 ? -1 : 0,
          maxX: weights.length == 1 ? 1 : (weights.length - 1).toDouble(),
          minY: minValue - padding,
          maxY: maxValue + padding,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: Color.fromRGBO(255, 255, 255, 0.06),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  if (value == meta.min || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(value.toStringAsFixed(1), style: _labelStyle),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  // Label only the first and last points to avoid crowding.
                  final isEdge = index == 0 || index == weights.length - 1;
                  if (value != index || !isEdge || index >= weights.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      dateFormat.format(weights[index].loggedAt),
                      style: _labelStyle,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF272A2E),
              getTooltipItems: (spots) => spots
                  .map(
                    (spot) => LineTooltipItem(
                      "${spot.y.toStringAsFixed(1)} kg\n"
                      "${dateFormat.format(weights[spot.x.toInt()].loggedAt)}",
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (final (index, value) in values.indexed)
                  FlSpot(index.toDouble(), value),
              ],
              color: _lineColor,
              barWidth: 2,
              dotData: FlDotData(
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      radius: 3,
                      color: const Color(0xFF0B0D10),
                      strokeWidth: 1.6,
                      strokeColor: _lineColor,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_lineColor.withAlpha(90), _lineColor.withAlpha(0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
