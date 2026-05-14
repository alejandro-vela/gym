import '../../i18n/strings/app_strings.dart';
import '../../i18n/strings/common_strings.dart';
import '../../i18n/strings/recovery_strings.dart';
import '../../i18n/strings/routine_strings.dart';
import '../machine.dart';
import '../routine_exercise.dart';

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
