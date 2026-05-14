import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/body_measurement.dart';
import '../../../theme/app_theme.dart';

class WeightChart extends StatelessWidget {
  const WeightChart({super.key, required this.measurements});
  final List<BodyMeasurement> measurements;

  @override
  Widget build(BuildContext context) {
    final List<BodyMeasurement> weightsWithDate = measurements
        .where((BodyMeasurement m) => m.weight != null)
        .toList()
        .reversed
        .toList();

    if (weightsWithDate.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<FlSpot> spots = weightsWithDate
        .asMap()
        .entries
        .map(
          (MapEntry<int, BodyMeasurement> e) =>
              FlSpot(e.key.toDouble(), e.value.weight!),
        )
        .toList();

    final double minW = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a < b ? a : b) -
        2;
    final double maxW = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a > b ? a : b) +
        2;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            getDrawingHorizontalLine: (_) => const FlLine(
              color: Color(0xFF2A2A2A),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (_) =>
                const FlLine(color: Colors.transparent),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double v, _) => Text(
                  '${v.toInt()}kg',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          minY: minW,
          maxY: maxW,
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.primaryOrange,
              barWidth: 2.5,
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              ),
              dotData: FlDotData(
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
