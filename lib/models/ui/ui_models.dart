import '../../i18n/app_localizations.dart';
import '../../providers/health_provider.dart';
import '../../providers/pr_streak_provider.dart';
import '../../services/health_service.dart';
import '../achievement.dart';
import '../body_measurement.dart';
import '../machine.dart';
import '../routine_exercise.dart';

// ─────────────────────────────────────────────────────────────────
// HOME MODEL
// ─────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────
// MACHINES MODEL
// ─────────────────────────────────────────────────────────────────
class MachinesModel {

  const MachinesModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.machines,
    required this.categories,
    required this.selectedCategory,
    required this.isLoading,
  });
  final MachinesStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final List<Machine> machines;
  final List<String> categories; // [filterAll, ...kCategories]
  final String selectedCategory;
  final bool isLoading;
}

// ─────────────────────────────────────────────────────────────────
// MACHINE DETAIL MODEL
// ─────────────────────────────────────────────────────────────────
class MachineDetailModel {

  const MachineDetailModel({
    required this.strings,
    required this.addStrings,
    required this.common,
    required this.images,
    required this.machine,
  });
  final MachinesStrings strings;
  final AddMachineStrings addStrings;
  final CommonStrings common;
  final ImagePaths images;
  final Machine machine;
}

// ─────────────────────────────────────────────────────────────────
// ADD / EDIT MACHINE MODEL
// ─────────────────────────────────────────────────────────────────
class AddMachineModel {

  const AddMachineModel({
    required this.strings,
    required this.machineStrings,
    required this.common,
    required this.images,
    this.existingMachine,
  });
  final AddMachineStrings strings;
  final MachinesStrings machineStrings;
  final CommonStrings common;
  final ImagePaths images;
  final Machine? existingMachine; // null = new, non-null = edit

  bool get isEditing => existingMachine != null;
}

// ─────────────────────────────────────────────────────────────────
// ROUTINE MODEL
// ─────────────────────────────────────────────────────────────────
class RoutineModel {

  const RoutineModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.selectedDay,
    required this.todayWeekday,
    required this.exercises,
    required this.isLoading,
  });
  final RoutineStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final int selectedDay;
  final int todayWeekday;
  final List<RoutineExercise> exercises;
  final bool isLoading;

  bool get isToday => selectedDay == todayWeekday;
  String get selectedDayName => strings.dayName(selectedDay);
  String get selectedDayShort => strings.dayShort(selectedDay);
}

// ─────────────────────────────────────────────────────────────────
// ADD EXERCISE MODEL
// ─────────────────────────────────────────────────────────────────
class AddExerciseModel {

  const AddExerciseModel({
    required this.strings,
    required this.common,
    required this.routineStrings,
    required this.dayOfWeek,
    required this.availableMachines,
    this.existingExercise,
  });
  final AddExerciseStrings strings;
  final CommonStrings common;
  final RoutineStrings routineStrings;

  final int dayOfWeek;
  final RoutineExercise? existingExercise;
  final List<Machine> availableMachines;

  bool get isEditing => existingExercise != null;
  String get dayName => routineStrings.dayName(dayOfWeek);
}

// ─────────────────────────────────────────────────────────────────
// WORKOUT SESSION MODEL
// ─────────────────────────────────────────────────────────────────
class WorkoutSessionModel {

  const WorkoutSessionModel({
    required this.strings,
    required this.common,
    required this.overloadStrings,
    required this.images,
    required this.dayOfWeek,
    required this.exercises,
    required this.sessionId,
  });
  final WorkoutSessionStrings strings;
  final CommonStrings common;
  final OverloadStrings overloadStrings;
  final ImagePaths images;

  final int dayOfWeek;
  final List<RoutineExercise> exercises;
  final int? sessionId;
}

// ─────────────────────────────────────────────────────────────────
// PROGRESS MODEL
// ─────────────────────────────────────────────────────────────────
class ProgressModel {

  const ProgressModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.measurements,
    required this.sessions,
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.latestMeasurement,
    required this.isLoading,
  });
  final ProgressStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final List<BodyMeasurement> measurements;
  final List<WorkoutSession> sessions;
  final int totalWorkouts;
  final int totalMinutes;
  final BodyMeasurement? latestMeasurement;
  final bool isLoading;
}

// ─────────────────────────────────────────────────────────────────
// HEALTH MODEL
// ─────────────────────────────────────────────────────────────────
class HealthModel { // e.g. "Sincronizado 14:30"

  const HealthModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.permissionStatus,
    required this.summary,
    required this.heartRateSamples,
    required this.isLoading,
    required this.error,
    required this.calorieGoal,
    required this.calorieProgress,
    required this.syncedTimeLabel,
  });
  final HealthStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final HealthPermissionStatus permissionStatus;
  final TodayHealthSummary? summary;
  final List<HealthSample> heartRateSamples;
  final bool isLoading;
  final String? error;
  final double calorieGoal;
  final double calorieProgress;
  final String syncedTimeLabel;
}

// ─────────────────────────────────────────────────────────────────
// ACHIEVEMENTS MODEL
// ─────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────
// RECOVERY MODEL
// ─────────────────────────────────────────────────────────────────
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

  // Computed from muscleStatus
  final List<String> fatiguedMuscles;
  final List<String> recoveringMuscles;

  bool get allFresh => fatiguedMuscles.isEmpty && recoveringMuscles.isEmpty;
}
