import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../models/routine_exercise.dart';
import '../../../theme/app_theme.dart';

class RoutineSummaryCard extends StatelessWidget {
  const RoutineSummaryCard({
    super.key,
    required this.exercises,
    required this.isToday,
    required this.onStartWorkout,
  });
  final List<RoutineExercise> exercises;
  final bool isToday;
  final VoidCallback onStartWorkout;

  @override
  Widget build(BuildContext context) {
    final RoutineStrings strings =
        context.read<LanguageProvider>().strings.routine;
    final int totalSets = exercises.fold(
      0,
      (int sum, RoutineExercise e) => sum + e.targetSets,
    );
    final int totalReps = exercises.fold(
      0,
      (int sum, RoutineExercise e) => sum + (e.targetSets * e.targetReps),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppTheme.primaryOrange.withValues(alpha: 0.15),
            AppTheme.primaryOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.exercisesCount(exercises.length),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${strings.setsCount(totalSets)} · ${strings.totalReps(totalReps)}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isToday)
            ElevatedButton.icon(
              onPressed: onStartWorkout,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text(strings.startTraining),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                textStyle: const TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
