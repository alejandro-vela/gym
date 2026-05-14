import 'package:flutter/material.dart';

import '../../../models/routine_exercise.dart';
import '../../../models/ui/home_model.dart';
import '../../../theme/app_theme.dart';

class HomeExerciseTile extends StatelessWidget {
  const HomeExerciseTile({
    super.key,
    required this.model,
    required this.exercise,
  });
  final HomeModel model;
  final RoutineExercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: AppTheme.primaryOrange,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  exercise.exerciseName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${exercise.targetSets} ${model.common.sets} × '
                  '${exercise.targetReps} ${model.common.reps} · '
                  '${exercise.targetWeight}${model.common.kg}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTodaySectionHeader extends StatelessWidget {
  const HomeTodaySectionHeader({
    super.key,
    required this.model,
    required this.onStartTap,
  });
  final HomeModel model;
  final VoidCallback onStartTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '${model.strings.todayLabel} — ${model.todayDayName}',
          style:
              Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
        ),
        if (model.todayExercises.isNotEmpty && !model.hasActiveSession)
          TextButton(
            onPressed: onStartTap,
            child: Text(model.strings.startWorkout),
          ),
      ],
    );
  }
}

class HomeRestDayCard extends StatelessWidget {
  const HomeRestDayCard({super.key, required this.model});
  final HomeModel model;

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
            Icons.hotel_rounded,
            color: AppTheme.textSecondary,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            model.strings.restDayTitle,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
            ),
          ),
          Text(
            model.strings.restDayHint,
            style: const TextStyle(color: Color(0xFF555555), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
