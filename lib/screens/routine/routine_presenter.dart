import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/routine_exercise.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/routine_provider.dart';
import '../../providers/workout_provider.dart';

abstract class RoutineView extends BaseView<RoutineModel> {
  @override
  void setUI(RoutineModel model);
  void navigateToAddExercise(int dayOfWeek);
  void navigateToEditExercise(RoutineExercise exercise);
  void navigateToWorkoutSession(int dayOfWeek, List<RoutineExercise> exercises);
}

class RoutinePresenter extends BasePresenter<RoutineView> {
  RoutinePresenter({required super.view});
  RoutineProvider? _routineProvider;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    _routineProvider ??= context.read<RoutineProvider>()..addListener(_onDataChanged);
    _buildAndDeliver(context);
  }

  @override
  void dispose() {
    _routineProvider?.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (_ctx != null) {
      _buildAndDeliver(_ctx!);
    }
  }

  void _buildAndDeliver(BuildContext context) {
    final AppLocalizations s = context.read<LanguageProvider>().strings;
    final RoutineProvider provider = context.read<RoutineProvider>();
    view.setUI(
      RoutineModel(
        strings: s.routine,
        images: s.images,
        common: s.common,
        selectedDay: provider.selectedDay,
        todayWeekday: DateTime.now().weekday,
        exercises: provider.exercisesForDay(provider.selectedDay),
        isLoading: provider.isLoading,
      ),
    );
  }

  void onDaySelected(BuildContext context, int day) {
    context.read<RoutineProvider>().selectDay(day);
  }

  void onAddExerciseTap(BuildContext context) {
    final int day = context.read<RoutineProvider>().selectedDay;
    view.navigateToAddExercise(day);
  }

  void onEditExerciseTap(RoutineExercise exercise) =>
      view.navigateToEditExercise(exercise);

  Future<void> deleteExercise(
    BuildContext context,
    RoutineExercise exercise,
  ) async {
    await context.read<RoutineProvider>().deleteExercise(exercise);
  }

  Future<void> startWorkout(BuildContext context) async {
    final RoutineProvider routineProvider = context.read<RoutineProvider>();
    final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
    final int day = routineProvider.selectedDay;
    final List<RoutineExercise> exercises =
        routineProvider.exercisesForDay(day);
    if (exercises.isEmpty) {
      return;
    }
    if (!workoutProvider.isActive) {
      await workoutProvider.startSession(day);
    }
    view.navigateToWorkoutSession(day, exercises);
  }
}
