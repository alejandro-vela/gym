import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/routine_exercise.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/pr_streak_provider.dart';
import '../../providers/routine_provider.dart';
import '../../providers/workout_provider.dart';
import '../../services/database_service.dart';

// ─── Interface ────────────────────────────────────────────────────
abstract class HomeView extends BaseView<HomeModel> {
  @override
  void setUI(HomeModel model);
  void navigateToWorkout(int dayOfWeek, List<RoutineExercise> exercises);
}

// ─── Presenter ───────────────────────────────────────────────────
class HomePresenter extends BasePresenter<HomeView> {
  HomePresenter({required super.view});
  RoutineProvider? _routineProvider;
  WorkoutProvider? _workoutProvider;
  PrStreakProvider? _prStreakProvider;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    _routineProvider ??= context.read<RoutineProvider>()..addListener(_onDataChanged);
    _workoutProvider ??= context.read<WorkoutProvider>()..addListener(_onDataChanged);
    _prStreakProvider ??= context.read<PrStreakProvider>()..addListener(_onDataChanged);
    unawaited(_buildAndDeliver(context));
  }

  @override
  void dispose() {
    _routineProvider?.removeListener(_onDataChanged);
    _workoutProvider?.removeListener(_onDataChanged);
    _prStreakProvider?.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (_ctx != null) {
      unawaited(_buildAndDeliver(_ctx!));
    }
  }

  Future<void> _buildAndDeliver(BuildContext context) async {
    final AppLocalizations s = context.read<LanguageProvider>().strings;
    final RoutineProvider routineProvider = context.read<RoutineProvider>();
    final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
    final PrStreakProvider prProvider = context.read<PrStreakProvider>();
    final int today = DateTime.now().weekday;
    final int totalMachines =
        await DatabaseService.instance.getTotalMachines();
    final int totalWorkouts =
        await DatabaseService.instance.getTotalWorkouts();
    final int tipIndex = DateTime.now().day % s.home.tips.length;

    view.setUI(
      HomeModel(
        strings: s.home,
        images: s.images,
        common: s.common,
        todayDateLabel: DateFormat('d MMM yyyy').format(DateTime.now()),
        todayWeekday: today,
        todayDayName: s.routine.dayName(today),
        todayExercises: routineProvider.exercisesForDay(today),
        totalMachines: totalMachines,
        totalWorkouts: totalWorkouts,
        currentStreak: prProvider.currentStreak,
        hasActiveSession: workoutProvider.isActive,
        sessionStart: workoutProvider.sessionStart,
        tipOfDay: s.home.tips[tipIndex],
      ),
    );
  }

  Future<void> startWorkout(BuildContext context) async {
    final RoutineProvider routineProvider = context.read<RoutineProvider>();
    final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
    final int today = DateTime.now().weekday;
    final List<RoutineExercise> exercises =
        routineProvider.exercisesForDay(today);
    if (exercises.isEmpty) {
      return;
    }
    if (!workoutProvider.isActive) {
      await workoutProvider.startSession(today);
    }
    view.navigateToWorkout(today, exercises);
  }
}
