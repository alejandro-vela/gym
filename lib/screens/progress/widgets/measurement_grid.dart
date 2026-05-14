import 'package:flutter/material.dart';

import '../../../i18n/app_localizations.dart';
import '../../../models/body_measurement.dart';
import '../../../theme/app_theme.dart';

class MeasurementGrid extends StatelessWidget {
  const MeasurementGrid({
    super.key,
    required this.measurement,
    required this.strings,
  });
  final BodyMeasurement measurement;
  final ProgressStrings strings;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = <Map<String, dynamic>>[
      if (measurement.weight != null)
        <String, dynamic>{
          'label': strings.measurementWeight,
          'value': '${measurement.weight!.toStringAsFixed(1)}kg',
          'color': AppTheme.primaryOrange,
        },
      if (measurement.bodyFatPercent != null)
        <String, dynamic>{
          'label': strings.measurementBodyFat,
          'value': '${measurement.bodyFatPercent!.toStringAsFixed(1)}%',
          'color': AppTheme.warning,
        },
      if (measurement.chest != null)
        <String, dynamic>{
          'label': strings.measurementChest,
          'value': '${measurement.chest}cm',
          'color': AppTheme.info,
        },
      if (measurement.waist != null)
        <String, dynamic>{
          'label': strings.measurementWaist,
          'value': '${measurement.waist}cm',
          'color': AppTheme.success,
        },
      if (measurement.leftArm != null)
        <String, dynamic>{
          'label': strings.measurementArmLeft,
          'value': '${measurement.leftArm}cm',
          'color': AppTheme.info,
        },
      if (measurement.rightArm != null)
        <String, dynamic>{
          'label': strings.measurementArmRight,
          'value': '${measurement.rightArm}cm',
          'color': AppTheme.info,
        },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.4,
      ),
      itemCount: items.length,
      itemBuilder: (_, int i) {
        final Map<String, dynamic> item = items[i];
        final Color color = item['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                item['value'] as String,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item['label'] as String,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
