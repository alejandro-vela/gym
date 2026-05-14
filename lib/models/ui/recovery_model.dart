import '../../i18n/strings/app_strings.dart';
import '../../i18n/strings/common_strings.dart';
import '../../i18n/strings/recovery_strings.dart';
import '../../providers/pr_streak_provider.dart';
import '../achievement.dart';

class RecoveryModel {
  const RecoveryModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.muscleStatus,
    required this.recoveryPercents,
    required this.latestByMuscle,
    required this.isLoading,
    required this.fatiguedMuscles,
    required this.recoveringMuscles,
  });

  final RecoveryStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final Map<String, MuscleStatus> muscleStatus;
  final Map<String, double> recoveryPercents;
  final Map<String, MuscleRecoveryEntry?> latestByMuscle;
  final bool isLoading;

  final List<String> fatiguedMuscles;
  final List<String> recoveringMuscles;

  bool get allFresh => fatiguedMuscles.isEmpty && recoveringMuscles.isEmpty;
}
