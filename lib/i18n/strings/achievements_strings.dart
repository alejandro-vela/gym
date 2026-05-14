class StreakMilestone {
  const StreakMilestone({
    required this.days,
    required this.label,
    required this.emoji,
  });

  factory StreakMilestone.fromJson(Map<String, dynamic> j) => StreakMilestone(
        days: j['days'] as int,
        label: j['label'] as String,
        emoji: j['emoji'] as String,
      );

  final int days;
  final String label;
  final String emoji;
}

class AchievementsStrings {
  const AchievementsStrings({
    required this.title,
    required this.tabPrs,
    required this.tabStreak,
    required this.tabAchievements,
    required this.prsEmptyTitle,
    required this.prsEmptyBody,
    required this.prsBestLabel,
    required this.prsTapHint,
    required this.prs1rmLabel,
    required this.prsChartTitle,
    required this.streakCurrent,
    required this.streakBest,
    required this.streakMilestones,
    required this.streakMotivation0,
    required this.streakMotivation3,
    required this.streakMotivation7,
    required this.streakMotivation14,
    required this.streakMotivation30,
    required this.streakMotivationMax,
    required this.achievementsCollection,
    required this.achievementsUnlocked,
    required this.achievementsLocked,
    required this.prBannerTitle,
    required this.prBanner1rm,
  });

  factory AchievementsStrings.fromJson(Map<String, dynamic> j) =>
      AchievementsStrings(
        title: j['title'] as String,
        tabPrs: j['tab_prs'] as String,
        tabStreak: j['tab_streak'] as String,
        tabAchievements: j['tab_achievements'] as String,
        prsEmptyTitle: j['prs_empty_title'] as String,
        prsEmptyBody: j['prs_empty_body'] as String,
        prsBestLabel: j['prs_best_label'] as String,
        prsTapHint: j['prs_tap_hint'] as String,
        prs1rmLabel: j['prs_1rm_label'] as String,
        prsChartTitle: j['prs_chart_title'] as String,
        streakCurrent: j['streak_current'] as String,
        streakBest: j['streak_best'] as String,
        streakMilestones: (j['streak_milestones'] as List<dynamic>)
            .map(
              (dynamic m) =>
                  StreakMilestone.fromJson(m as Map<String, dynamic>),
            )
            .toList(),
        streakMotivation0: j['streak_motivation_0'] as String,
        streakMotivation3: j['streak_motivation_3'] as String,
        streakMotivation7: j['streak_motivation_7'] as String,
        streakMotivation14: j['streak_motivation_14'] as String,
        streakMotivation30: j['streak_motivation_30'] as String,
        streakMotivationMax: j['streak_motivation_max'] as String,
        achievementsCollection: j['achievements_collection'] as String,
        achievementsUnlocked: j['achievements_unlocked'] as String,
        achievementsLocked: j['achievements_locked'] as String,
        prBannerTitle: j['pr_banner_title'] as String,
        prBanner1rm: j['pr_banner_1rm'] as String,
      );

  final String title;
  final String tabPrs;
  final String tabStreak;
  final String tabAchievements;
  final String prsEmptyTitle;
  final String prsEmptyBody;
  final String prsBestLabel;
  final String prsTapHint;
  final String prs1rmLabel;
  final String prsChartTitle;
  final String streakCurrent;
  final String streakBest;
  final List<StreakMilestone> streakMilestones;
  final String streakMotivation0;
  final String streakMotivation3;
  final String streakMotivation7;
  final String streakMotivation14;
  final String streakMotivation30;
  final String streakMotivationMax;
  final String achievementsCollection;
  final String achievementsUnlocked;
  final String achievementsLocked;
  final String prBannerTitle;
  final String prBanner1rm;

  String streakBestDays(int days) => streakBest.replaceAll('{days}', '$days');
  String chartTitle(String exercise) =>
      prsChartTitle.replaceAll('{exercise}', exercise);
  String motivation(int streak) {
    if (streak == 0) {
      return streakMotivation0;
    }
    if (streak < 3) {
      return streakMotivation3;
    }
    if (streak < 7) {
      return streakMotivation7;
    }
    if (streak < 14) {
      return streakMotivation14;
    }
    if (streak < 30) {
      return streakMotivation30;
    }
    return streakMotivationMax.replaceAll('{days}', '$streak');
  }

  String banner1rm(String value) => prBanner1rm.replaceAll('{value}', value);
}
