import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../i18n/app_localizations.dart';
import '../../../services/health_service.dart';
import '../../../theme/app_theme.dart';

class HealthWorkoutCard extends StatelessWidget {
  const HealthWorkoutCard({super.key, required this.workout});
  final HealthWorkout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.watch_rounded,
              color: AppTheme.primaryOrange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  workout.type,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${workout.durationMinutes} min · ${workout.calories.round()} kcal',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                DateFormat('d MMM').format(workout.date),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(workout.date),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HealthNoWorkoutsCard extends StatelessWidget {
  const HealthNoWorkoutsCard({super.key, required this.strings});
  final HealthStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.watch_off_rounded,
            color: AppTheme.textSecondary,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            strings.noWorkoutsTitle,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          Text(
            strings.noWorkoutsBody,
            style: const TextStyle(color: Color(0xFF555555), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
