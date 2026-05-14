import 'package:flutter/material.dart';

import '../../../i18n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class HealthSleepCard extends StatelessWidget {
  const HealthSleepCard({
    super.key,
    required this.strings,
    required this.hours,
  });
  final HealthStrings strings;
  final double hours;

  Color get _sleepColor {
    if (hours >= 8) {
      return AppTheme.success;
    }
    if (hours >= 6) {
      return AppTheme.warning;
    }
    return AppTheme.danger;
  }

  String _sleepLabel() {
    if (hours >= 8) {
      return strings.sleepOptimal;
    }
    if (hours >= 6) {
      return strings.sleepRegular;
    }
    return strings.sleepInsufficient;
  }

  @override
  Widget build(BuildContext context) {
    final int h = hours.floor();
    final int m = ((hours - h) * 60).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sleepColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _sleepColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bedtime_rounded, color: _sleepColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      strings.sleepTitle,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _sleepColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _sleepLabel(),
                        style: TextStyle(
                          color: _sleepColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Text(
                      '${h}h ${m}min',
                      style: TextStyle(
                        color: _sleepColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      strings.sleepLastNight,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
