import 'package:flutter/material.dart';

import '../../../i18n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class ExerciseDayBanner extends StatelessWidget {
  const ExerciseDayBanner({
    super.key,
    required this.strings,
    required this.dayOfWeek,
  });
  final RoutineStrings strings;
  final int dayOfWeek;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.today_rounded,
            color: AppTheme.primaryOrange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            strings.dayName(dayOfWeek),
            style: const TextStyle(
              color: AppTheme.primaryOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
