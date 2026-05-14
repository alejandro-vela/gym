import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../i18n/strings/achievements_strings.dart';
import '../../../providers/pr_streak_provider.dart';
import '../../../theme/app_theme.dart';

class StreakTab extends StatelessWidget {
  const StreakTab({super.key, required this.provider});
  final PrStreakProvider provider;

  @override
  Widget build(BuildContext context) {
    final AchievementsStrings s =
        context.read<LanguageProvider>().strings.achievements;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        StreakHeroCard(
          strings: s,
          current: provider.currentStreak,
          longest: provider.longestStreak,
        ),
        const SizedBox(height: 20),
        MotivationCard(strings: s, streak: provider.currentStreak),
        const SizedBox(height: 20),
        Text(
          s.achievementsCollection,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...s.streakMilestones.map(
          (StreakMilestone m) => MilestoneTile(
            days: m.days,
            label: m.label,
            emoji: m.emoji,
            current: provider.currentStreak,
            strings: s,
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class StreakHeroCard extends StatelessWidget {
  const StreakHeroCard({
    super.key,
    required this.strings,
    required this.current,
    required this.longest,
  });
  final AchievementsStrings strings;
  final int current;
  final int longest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppTheme.primaryOrange, Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          const Text('🔥', style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(
            '$current',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          Text(
            strings.streakCurrent,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              strings.streakBestDays(longest),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MotivationCard extends StatelessWidget {
  const MotivationCard({
    super.key,
    required this.strings,
    required this.streak,
  });
  final AchievementsStrings strings;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.emoji_events_rounded,
            color: AppTheme.primaryOrange,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              strings.motivation(streak),
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MilestoneTile extends StatelessWidget {
  const MilestoneTile({
    super.key,
    required this.days,
    required this.label,
    required this.emoji,
    required this.current,
    required this.strings,
  });
  final int days;
  final String label;
  final String emoji;
  final int current;
  final AchievementsStrings strings;

  @override
  Widget build(BuildContext context) {
    final bool reached = current >= days;
    final double pct = (current / days).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: reached
            ? AppTheme.success.withValues(alpha: 0.08)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: reached
              ? AppTheme.success.withValues(alpha: 0.3)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    color: reached
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                    fontWeight:
                        reached ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (!reached) ...<Widget>[
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: const Color(0xFF2A2A2A),
                      color: AppTheme.primaryOrange,
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (reached)
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
              size: 20,
            )
          else
            Text(
              strings.streakBestDays(days),
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
