import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../services/health_service.dart';
import '../../../theme/app_theme.dart';

class HealthHeartRateCard extends StatelessWidget {
  const HealthHeartRateCard({
    super.key,
    required this.strings,
    required this.latest,
    this.avg,
    this.max,
    required this.samples,
  });
  final HealthStrings strings;
  final double latest;
  final double? avg;
  final double? max;
  final List<HealthSample> samples;

  Color get _zoneColor {
    if (latest < 60) {
      return AppTheme.info;
    }
    if (latest < 100) {
      return AppTheme.success;
    }
    if (latest < 140) {
      return AppTheme.warning;
    }
    return AppTheme.danger;
  }

  String _zoneLabel() {
    if (latest < 60) {
      return strings.zoneRest;
    }
    if (latest < 100) {
      return strings.zoneNormal;
    }
    if (latest < 140) {
      return strings.zoneModerate;
    }
    return strings.zoneIntense;
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = samples
        .asMap()
        .entries
        .map(
          (MapEntry<int, HealthSample> e) =>
              FlSpot(e.key.toDouble(), e.value.value),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _zoneColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.favorite_rounded, color: _zoneColor, size: 20),
              const SizedBox(width: 8),
              Text(
                strings.heartRateTitle,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _zoneColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _zoneLabel(),
                  style: TextStyle(
                    color: _zoneColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Builder(
            builder: (BuildContext ctx) {
              final String bpm =
                  ctx.read<LanguageProvider>().strings.common.bpm;
              return Row(
                children: <Widget>[
                  HRStat(
                    label: strings.hrCurrent,
                    value: '${latest.round()}',
                    unit: bpm,
                    color: _zoneColor,
                    large: true,
                  ),
                  if (avg != null) ...<Widget>[
                    const SizedBox(width: 20),
                    HRStat(
                      label: strings.hrAvg,
                      value: '${avg!.round()}',
                      unit: bpm,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                  if (max != null) ...<Widget>[
                    const SizedBox(width: 20),
                    HRStat(
                      label: strings.hrMax,
                      value: '${max!.round()}',
                      unit: bpm,
                      color: AppTheme.danger,
                    ),
                  ],
                ],
              );
            },
          ),
          if (spots.length >= 3) ...<Widget>[
            const SizedBox(height: 16),
            SizedBox(
              height: 70,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: _zoneColor,
                      belowBarData: BarAreaData(
                        show: true,
                        color: _zoneColor.withValues(alpha: 0.1),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.hrChartHint,
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HRStat extends StatelessWidget {
  const HRStat({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    this.large = false,
  });
  final String label;
  final String value;
  final String unit;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: large ? 32 : 20,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                unit,
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: large ? 13 : 11,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
