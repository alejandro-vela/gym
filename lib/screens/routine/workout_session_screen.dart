import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/routine_exercise.dart';
import '../../providers/pr_streak_provider.dart';
import '../../providers/workout_provider.dart';
import '../../services/progressive_overload_service.dart';
import '../../theme/app_theme.dart';
import 'widgets/workout_rest_timer.dart';
import 'widgets/workout_session_header.dart';
import 'widgets/workout_set_row.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({
    super.key,
    required this.dayOfWeek,
    required this.exercises,
  });
  final int dayOfWeek;
  final List<RoutineExercise> exercises;

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentExerciseIndex = 0;
  final Map<int, List<WorkoutSetEntry>> _exerciseSets =
      <int, List<WorkoutSetEntry>>{};
  Timer? _sessionTimer;
  int _sessionSeconds = 0;
  bool _isRestTimerActive = false;
  int _restSeconds = 0;
  Timer? _restTimer;

  RoutineExercise get _currentExercise =>
      widget.exercises[_currentExerciseIndex];

  List<WorkoutSetEntry> get _currentSets =>
      _exerciseSets[_currentExerciseIndex] ?? <WorkoutSetEntry>[];

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
    for (int i = 0; i < widget.exercises.length; i++) {
      final RoutineExercise ex = widget.exercises[i];
      _exerciseSets[i] = List<WorkoutSetEntry>.generate(
        ex.targetSets,
        (int j) => WorkoutSetEntry(
          setNumber: j + 1,
          reps: ex.targetReps,
          weight: ex.targetWeight,
        ),
      );
    }
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _sessionSeconds++);
      }
    });
  }

  void _startRestTimer({int seconds = 90}) {
    _restTimer?.cancel();
    setState(() {
      _isRestTimerActive = true;
      _restSeconds = seconds;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_restSeconds <= 0) {
        _restTimer?.cancel();
        if (mounted) {
          setState(() => _isRestTimerActive = false);
        }
      } else {
        if (mounted) {
          setState(() => _restSeconds--);
        }
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _isRestTimerActive = false;
      _restSeconds = 0;
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  String get _sessionTime {
    final int m = _sessionSeconds ~/ 60;
    final int s = _sessionSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _completeSet(int setIndex) async {
    final WorkoutSetEntry set = _currentSets[setIndex];
    if (set.completed) {
      return;
    }

    final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
    await workoutProvider.logSet(
      exercise: _currentExercise,
      setNumber: set.setNumber,
      reps: set.reps,
      weight: set.weight,
    );

    setState(() => _currentSets[setIndex].completed = true);
    unawaited(HapticFeedback.heavyImpact());

    _startRestTimer();
  }

  Future<void> _finishWorkout() async {
    final WorkoutSessionStrings ws =
        context.read<LanguageProvider>().strings.workoutSession;
    final CommonStrings cs = context.read<LanguageProvider>().strings.common;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: Text(
          ws.finishDialogTitle,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          ws.finishBody(_sessionTime),
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cs.continueStr),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(cs.finish),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
      final PrStreakProvider prProvider = context.read<PrStreakProvider>();
      final int? sessionId = workoutProvider.activeSession?.id;

      final Map<int, List<CompletedSetData>> completedMap =
          <int, List<CompletedSetData>>{};
      for (int i = 0; i < widget.exercises.length; i++) {
        final RoutineExercise ex = widget.exercises[i];
        if (ex.id == null) {
          continue;
        }
        final List<WorkoutSetEntry> sets =
            _exerciseSets[i] ?? <WorkoutSetEntry>[];
        completedMap[ex.id!] = sets
            .map(
              (WorkoutSetEntry s) => CompletedSetData(
                setNumber: s.setNumber,
                reps: s.reps,
                weight: s.weight,
                completed: s.completed,
              ),
            )
            .toList();
      }

      if (sessionId != null) {
        await prProvider.processCompletedSession(
          sessionId: sessionId,
          exercises: widget.exercises,
          completedSetsByExerciseId: completedMap,
          dayOfWeek: widget.dayOfWeek,
        );
      }

      await workoutProvider.endSession();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final WorkoutSessionStrings ws =
            context.read<LanguageProvider>().strings.workoutSession;
        final CommonStrings cs =
            context.read<LanguageProvider>().strings.common;
        final bool? leave = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppTheme.cardDark,
            title: Text(
              ws.leaveDialogTitle,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            content: Text(
              ws.leaveDialogBody,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cs.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  ws.leaveConfirm,
                  style: const TextStyle(color: AppTheme.danger),
                ),
              ),
            ],
          ),
        );
        if ((leave ?? false) && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Column(
          children: <Widget>[
            WorkoutSessionHeader(
              sessionTime: _sessionTime,
              currentIndex: _currentExerciseIndex,
              total: widget.exercises.length,
              onFinish: _finishWorkout,
            ),

            if (_isRestTimerActive)
              WorkoutRestTimerBanner(
                seconds: _restSeconds,
                onSkip: _skipRest,
              ),

            WorkoutExerciseNavigation(
              exercises: widget.exercises
                  .map((RoutineExercise e) => e.exerciseName)
                  .toList(),
              currentIndex: _currentExerciseIndex,
              onSelect: (int i) =>
                  setState(() => _currentExerciseIndex = i),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _currentExercise.exerciseName,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_currentExercise.targetSets}×${_currentExercise.targetReps}',
                      style: const TextStyle(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _currentSets.length,
                itemBuilder: (_, int i) => WorkoutSetRow(
                  entry: _currentSets[i],
                  index: i,
                  onWeightChanged: (double w) =>
                      setState(() => _currentSets[i].weight = w),
                  onRepsChanged: (int r) =>
                      setState(() => _currentSets[i].reps = r),
                  onComplete: () => unawaited(_completeSet(i)),
                ),
              ),
            ),

            WorkoutBottomNavBar(
              canGoBack: _currentExerciseIndex > 0,
              canGoForward:
                  _currentExerciseIndex < widget.exercises.length - 1,
              onBack: () =>
                  setState(() => _currentExerciseIndex--),
              onForward: () =>
                  setState(() => _currentExerciseIndex++),
              isLast:
                  _currentExerciseIndex == widget.exercises.length - 1,
              onFinish: _finishWorkout,
            ),
          ],
        ),
      ),
    );
  }
}
