import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../models/body_measurement.dart';
import '../../../theme/app_theme.dart';

class MeasurementHistoryCard extends StatelessWidget {
  const MeasurementHistoryCard({
    super.key,
    required this.measurement,
    required this.onDelete,
  });
  final BodyMeasurement measurement;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('meas_${measurement.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_rounded, color: AppTheme.danger),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.monitor_weight_rounded,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat('d MMMM yyyy').format(measurement.date),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (measurement.weight != null)
                    Builder(
                      builder: (BuildContext ctx) {
                        final ProgressStrings ps =
                            ctx.read<LanguageProvider>().strings.progress;
                        return Text(
                          '${ps.measurementWeight}: ${measurement.weight!.toStringAsFixed(1)}kg'
                          '${measurement.waist != null ? ' · ${ps.measurementWaist}: ${measurement.waist}cm' : ''}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
