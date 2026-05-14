import '../../i18n/strings/app_strings.dart';
import '../../i18n/strings/common_strings.dart';
import '../../i18n/strings/home_strings.dart';
import '../routine_exercise.dart';

class HomeModel {
  const HomeModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.todayDateLabel,
    required this.todayWeekday,
    required this.todayDayName,
    required this.todayExercises,
    required this.totalMachines,
    required this.totalWorkouts,
    required this.currentStreak,
    required this.hasActiveSession,
    required this.sessionStart,
    required this.tipOfDay,
  });

  final HomeStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final String todayDateLabel;
  final int todayWeekday;
  final String todayDayName;
  final List<RoutineExercise> todayExercises;
  final int totalMachines;
  final int totalWorkouts;
  final int currentStreak;
  final bool hasActiveSession;
  final DateTime? sessionStart;
  final TipData tipOfDay;
}
