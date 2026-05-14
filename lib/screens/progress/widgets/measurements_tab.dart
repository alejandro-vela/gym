import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../models/body_measurement.dart';
import '../../../providers/workout_provider.dart';
import '../../../theme/app_theme.dart';
import 'measurement_grid.dart';
import 'measurement_history_card.dart';
import 'stat_box.dart';
import 'weight_chart.dart';

class MeasurementsTab extends StatelessWidget {
  const MeasurementsTab({super.key, required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    final ProgressStrings s = context.read<LanguageProvider>().strings.progress;
    final List<BodyMeasurement> measurements = provider.measurements;
    final BodyMeasurement? latest = provider.latestMeasurement;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Row(
          children: <Widget>[
            StatBox(
              label: s.statWorkouts,
              value: '${provider.totalWorkouts}',
              icon: Icons.fitness_center_rounded,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 12),
            StatBox(
              label: s.statMinutes,
              value: '${provider.totalMinutes}',
              icon: Icons.timer_rounded,
              color: AppTheme.info,
            ),
          ],
        ),
        const SizedBox(height: 20),

        if (measurements.length >= 2) ...<Widget>[
          _SectionTitle(s.sectionWeightChart),
          const SizedBox(height: 8),
          WeightChart(measurements: measurements),
          const SizedBox(height: 20),
        ],

        if (latest != null) ...<Widget>[
          _SectionTitle(s.sectionLatest),
          const SizedBox(height: 8),
          Text(
            DateFormat('d MMM yyyy').format(latest.date),
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          MeasurementGrid(measurement: latest, strings: s),
          const SizedBox(height: 20),
        ],

        _SectionTitle(s.sectionHistory),
        const SizedBox(height: 8),
        if (measurements.isEmpty)
          _EmptyMeasurements(
            title: s.emptyMeasurementsTitle,
            body: s.emptyMeasurementsBody,
          )
        else
          ...measurements.map(
            (BodyMeasurement m) => MeasurementHistoryCard(
              measurement: m,
              onDelete: () => unawaited(
                provider.deleteMeasurement(m.id!),
              ),
            ),
          ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EmptyMeasurements extends StatelessWidget {
  const _EmptyMeasurements({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.monitor_weight_rounded,
            color: AppTheme.textSecondary,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(color: Color(0xFF555555), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
