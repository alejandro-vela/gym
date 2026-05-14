import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/language_provider.dart';
import '../../../models/achievement.dart';
import '../../../theme/app_theme.dart';

class OneRmChart extends StatelessWidget {
  const OneRmChart({
    super.key,
    required this.exerciseName,
    required this.prs,
  });
  final String exerciseName;
  final List<PersonalRecord> prs;

  @override
  Widget build(BuildContext context) {
    if (prs.length < 2) {
      return const SizedBox.shrink();
    }

    final List<PersonalRecord> sorted = <PersonalRecord>[...prs]..sort(
        (PersonalRecord a, PersonalRecord b) =>
            a.achievedAt.compareTo(b.achievedAt),
      );
    final List<FlSpot> spots = sorted
        .asMap()
        .entries
        .map(
          (MapEntry<int, PersonalRecord> e) =>
              FlSpot(e.key.toDouble(), e.value.estimated1rm),
        )
        .toList();

    final double minY = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a < b ? a : b) -
        5;
    final double maxY = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a > b ? a : b) +
        5;

    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context
                .read<LanguageProvider>()
                .strings
                .achievements
                .chartTitle(exerciseName),
            style: const TextStyle(
              color: AppTheme.primaryOrange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (double v, _) => Text(
                        '${v.toInt()}kg',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                minY: minY,
                maxY: maxY,
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.primaryOrange,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      getDotPainter: (_, __, ___, ____) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
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
}
