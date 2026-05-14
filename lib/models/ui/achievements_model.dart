import '../../i18n/strings/achievements_strings.dart';
import '../../i18n/strings/app_strings.dart';
import '../../i18n/strings/common_strings.dart';
import '../achievement.dart';

class AchievementsModel {
  const AchievementsModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.allPrs,
    required this.bestPrByExercise,
    required this.currentStreak,
    required this.longestStreak,
    required this.achievements,
    required this.unlocked,
    required this.locked,
    required this.isLoading,
  });

  final AchievementsStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final List<PersonalRecord> allPrs;
  final Map<String, PersonalRecord> bestPrByExercise;
  final int currentStreak;
  final int longestStreak;
  final List<Achievement> achievements;
  final List<Achievement> unlocked;
  final List<Achievement> locked;
  final bool isLoading;

  String get streakMotivation => strings.motivation(currentStreak);
}
