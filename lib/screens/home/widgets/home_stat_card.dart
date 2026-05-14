import 'package:flutter/material.dart';

import '../../../models/ui/home_model.dart';
import '../../../theme/app_theme.dart';

class HomeStatsRow extends StatelessWidget {
  const HomeStatsRow({super.key, required this.model});
  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        HomeStatCard(
          icon: Icons.fitness_center_rounded,
          label: model.strings.statMachines,
          value: '${model.totalMachines}',
          color: AppTheme.primaryOrange,
        ),
        const SizedBox(width: 12),
        HomeStatCard(
          icon: Icons.check_circle_outline_rounded,
          label: model.strings.statWorkouts,
          value: '${model.totalWorkouts}',
          color: AppTheme.success,
        ),
        const SizedBox(width: 12),
        HomeStatCard(
          icon: Icons.today_rounded,
          label: model.strings.statTodayExercises,
          value: '${model.todayExercises.length}',
          color: AppTheme.info,
        ),
      ],
    );
  }
}

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
