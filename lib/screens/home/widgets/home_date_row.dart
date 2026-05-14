import 'package:flutter/material.dart';

import '../../../models/ui/home_model.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/pr_widgets.dart';
import '../../achievements/achievements_screen.dart';
import '../../recovery/muscle_recovery_screen.dart';
import 'home_tip_card.dart';

class HomeDateAndStreakRow extends StatelessWidget {
  const HomeDateAndStreakRow({
    super.key,
    required this.model,
    required this.onWorkoutTap,
  });
  final HomeModel model;
  final VoidCallback onWorkoutTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryOrange.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            '${model.todayDayName} · ${model.todayDateLabel}',
            style: const TextStyle(
              color: AppTheme.primaryOrange,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        StreakBadge(streak: model.currentStreak),
        const SizedBox(width: 8),
        HomeQuickLinkBtn(
          icon: Icons.map_rounded,
          label: model.strings.quickLinkRecovery,
          color: AppTheme.warning,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const MuscleRecoveryScreen(),
            ),
          ),
        ),
        const SizedBox(width: 6),
        HomeQuickLinkBtn(
          icon: Icons.emoji_events_rounded,
          label: model.strings.quickLinkPrs,
          color: AppTheme.primaryOrange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const AchievementsScreen(),
            ),
          ),
        ),
      ],
    );
  }
}
