import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../models/achievement.dart';
import '../../../providers/pr_streak_provider.dart';
import '../../../theme/app_theme.dart';

class AchievementsTab extends StatelessWidget {
  const AchievementsTab({super.key, required this.provider});
  final PrStreakProvider provider;

  @override
  Widget build(BuildContext context) {
    final AchievementsStrings s =
        context.read<LanguageProvider>().strings.achievements;
    final List<Achievement> achievements = provider.achievements;
    final List<Achievement> unlocked =
        achievements.where((Achievement a) => a.isUnlocked).toList();
    final List<Achievement> locked =
        achievements.where((Achievement a) => !a.isUnlocked).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    s.achievementsCollection,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${unlocked.length}/${achievements.length}',
                    style: const TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: achievements.isEmpty
                      ? 0
                      : unlocked.length / achievements.length,
                  backgroundColor: const Color(0xFF2A2A2A),
                  color: AppTheme.primaryOrange,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (unlocked.isNotEmpty) ...<Widget>[
          Text(
            s.achievementsUnlocked,
            style: const TextStyle(
              color: AppTheme.success,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...unlocked.map(
            (Achievement a) => AchievementCard(achievement: a),
          ),
          const SizedBox(height: 16),
        ],

        Text(
          s.achievementsLocked,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...locked.map(
          (Achievement a) => AchievementCard(achievement: a),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.achievement});
  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final bool unlocked = achievement.isUnlocked;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked
            ? AppTheme.success.withValues(alpha: 0.06)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked
              ? AppTheme.success.withValues(alpha: 0.25)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            achievement.emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: unlocked
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: unlocked
                        ? AppTheme.textSecondary
                        : const Color(0xFF444444),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
              size: 20,
            ),
        ],
      ),
    );
  }
}
