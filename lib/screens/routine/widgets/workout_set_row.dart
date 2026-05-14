import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/language_provider.dart';
import '../../../theme/app_theme.dart';

export 'workout_bottom_nav.dart';

class WorkoutSetEntry {
  WorkoutSetEntry({
    required this.setNumber,
    required this.reps,
    required this.weight,
  }) : completed = false;
  final int setNumber;
  int reps;
  double weight;
  bool completed;
}

class WorkoutSmallBtn extends StatelessWidget {
  const WorkoutSmallBtn({super.key, required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppTheme.primaryOrange.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14,
          color: onTap != null
              ? AppTheme.primaryOrange
              : AppTheme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class WorkoutSetRow extends StatelessWidget {
  const WorkoutSetRow({
    super.key,
    required this.entry,
    required this.index,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onComplete,
  });
  final WorkoutSetEntry entry;
  final int index;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: entry.completed
            ? AppTheme.success.withValues(alpha: 0.08)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: entry.completed
              ? AppTheme.success.withValues(alpha: 0.3)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: entry.completed
                  ? AppTheme.success
                  : AppTheme.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: entry.completed
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  )
                : Text(
                    '${entry.setNumber}',
                    style: const TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context
                      .read<LanguageProvider>()
                      .strings
                      .workoutSession
                      .weightLabel,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Row(
                  children: <Widget>[
                    WorkoutSmallBtn(
                      icon: Icons.remove_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onWeightChanged(
                                (entry.weight - 2.5).clamp(0, 999),
                              ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entry.weight.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    WorkoutSmallBtn(
                      icon: Icons.add_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onWeightChanged(
                                (entry.weight + 2.5).clamp(0, 999),
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context
                      .read<LanguageProvider>()
                      .strings
                      .workoutSession
                      .repsLabel,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Row(
                  children: <Widget>[
                    WorkoutSmallBtn(
                      icon: Icons.remove_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onRepsChanged(
                                (entry.reps - 1).clamp(1, 100),
                              ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.reps}',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    WorkoutSmallBtn(
                      icon: Icons.add_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onRepsChanged(
                                (entry.reps + 1).clamp(1, 100),
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: entry.completed ? null : onComplete,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: entry.completed
                    ? AppTheme.success
                    : AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                entry.completed
                    ? Icons.check_rounded
                    : Icons.done_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
