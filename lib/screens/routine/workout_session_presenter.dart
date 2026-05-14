import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/routine_exercise.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/pr_streak_provider.dart';
import '../../providers/workout_provider.dart';
import '../../services/progressive_overload_service.dart';

abstract class WorkoutSessionView extends BaseView<WorkoutSessionModel> {
  @override
  void setUI(WorkoutSessionModel model);
  void navigateBack();
}

class WorkoutSessionPresenter extends BasePresenter<WorkoutSessionView> {
  WorkoutSessionPresenter({
    required super.view,
    required this.dayOfWeek,
    required this.exercises,
  });
  final int dayOfWeek;
  final List<RoutineExercise> exercises;

  @override
  void getUI(BuildContext context) {
    final AppLocalizations s = context.read<LanguageProvider>().strings;
    final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
    view.setUI(
      WorkoutSessionModel(
        strings: s.workoutSession,
        common: s.common,
        overloadStrings: s.overload,
        images: s.images,
        dayOfWeek: dayOfWeek,
        exercises: exercises,
        sessionId: workoutProvider.activeSession?.id,
      ),
    );
  }

  Future<void> endSession(
    BuildContext context, {
    required Map<int, List<CompletedSetData>> completedSets,
  }) async {
    final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
    final PrStreakProvider prProvider = context.read<PrStreakProvider>();
    final int? sessionId = workoutProvider.activeSession?.id;

    if (sessionId != null) {
      await prProvider.processCompletedSession(
        sessionId: sessionId,
        exercises: exercises,
        completedSetsByExerciseId: completedSets,
        dayOfWeek: dayOfWeek,
      );
    }

    await workoutProvider.endSession();
    view.navigateBack();
  }

  Future<void> logSet(
    BuildContext context, {
    required RoutineExercise exercise,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    await context.read<WorkoutProvider>().logSet(
          exercise: exercise,
          setNumber: setNumber,
          reps: reps,
          weight: weight,
        );
  }
}
