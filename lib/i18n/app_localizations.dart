/// Complete typed data model for all app strings and image paths.
/// Every field maps 1-to-1 with a key in the JSON files.
/// No strings should ever be hardcoded in widgets — always use this model.
library;

import 'strings/achievements_strings.dart';
import 'strings/app_strings.dart';
import 'strings/common_strings.dart';
import 'strings/errors_strings.dart';
import 'strings/health_strings.dart';
import 'strings/home_strings.dart';
import 'strings/login_strings.dart';
import 'strings/machines_strings.dart';
import 'strings/nav_strings.dart';
import 'strings/progress_strings.dart';
import 'strings/recovery_strings.dart';
import 'strings/routine_strings.dart';

export 'strings/achievements_strings.dart';
export 'strings/app_strings.dart';
export 'strings/common_strings.dart';
export 'strings/errors_strings.dart';
export 'strings/health_strings.dart';
export 'strings/home_strings.dart';
export 'strings/login_strings.dart';
export 'strings/machines_strings.dart';
export 'strings/nav_strings.dart';
export 'strings/progress_strings.dart';
export 'strings/recovery_strings.dart';
export 'strings/routine_strings.dart';

// ─── Root model ───────────────────────────────────────────────────
class AppLocalizations {
  const AppLocalizations({
    required this.app,
    required this.images,
    required this.nav,
    required this.common,
    required this.login,
    required this.home,
    required this.machines,
    required this.addMachine,
    required this.routine,
    required this.addExercise,
    required this.workoutSession,
    required this.progress,
    required this.health,
    required this.achievements,
    required this.recovery,
    required this.overload,
    required this.errors,
    required this.workoutTypes,
  });

  factory AppLocalizations.fromJson(Map<String, dynamic> json) {
    return AppLocalizations(
      app: AppStrings.fromJson(json['app'] as Map<String, dynamic>),
      images: ImagePaths.fromJson(json['images'] as Map<String, dynamic>),
      nav: NavStrings.fromJson(json['nav'] as Map<String, dynamic>),
      common: CommonStrings.fromJson(json['common'] as Map<String, dynamic>),
      login: LoginStrings.fromJson(json['login'] as Map<String, dynamic>),
      home: HomeStrings.fromJson(json['home'] as Map<String, dynamic>),
      machines:
          MachinesStrings.fromJson(json['machines'] as Map<String, dynamic>),
      addMachine: AddMachineStrings.fromJson(
        json['add_machine'] as Map<String, dynamic>,
      ),
      routine: RoutineStrings.fromJson(json['routine'] as Map<String, dynamic>),
      addExercise: AddExerciseStrings.fromJson(
        json['add_exercise'] as Map<String, dynamic>,
      ),
      workoutSession: WorkoutSessionStrings.fromJson(
        json['workout_session'] as Map<String, dynamic>,
      ),
      progress:
          ProgressStrings.fromJson(json['progress'] as Map<String, dynamic>),
      health: HealthStrings.fromJson(json['health'] as Map<String, dynamic>),
      achievements: AchievementsStrings.fromJson(
        json['achievements'] as Map<String, dynamic>,
      ),
      recovery:
          RecoveryStrings.fromJson(json['recovery'] as Map<String, dynamic>),
      overload:
          OverloadStrings.fromJson(json['overload'] as Map<String, dynamic>),
      errors: ErrorStrings.fromJson(json['errors'] as Map<String, dynamic>),
      workoutTypes: WorkoutTypesStrings.fromJson(
        json['workout_types'] as Map<String, dynamic>,
      ),
    );
  }

  final AppStrings app;
  final ImagePaths images;
  final NavStrings nav;
  final CommonStrings common;
  final LoginStrings login;
  final HomeStrings home;
  final MachinesStrings machines;
  final AddMachineStrings addMachine;
  final RoutineStrings routine;
  final AddExerciseStrings addExercise;
  final WorkoutSessionStrings workoutSession;
  final ProgressStrings progress;
  final HealthStrings health;
  final AchievementsStrings achievements;
  final RecoveryStrings recovery;
  final OverloadStrings overload;
  final ErrorStrings errors;
  final WorkoutTypesStrings workoutTypes;
}
