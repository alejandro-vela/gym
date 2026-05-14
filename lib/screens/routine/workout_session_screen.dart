import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/routine_exercise.dart';
import '../../providers/pr_streak_provider.dart';
import '../../providers/workout_provider.dart';
import '../../services/progressive_overload_service.dart';
import '../../theme/app_theme.dart';

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
  final Map<int, List<_SetEntry>> _exerciseSets = <int, List<_SetEntry>>{};
  Timer? _sessionTimer;
  int _sessionSeconds = 0;
  bool _isRestTimerActive = false;
  int _restSeconds = 0;
  Timer? _restTimer;

  RoutineExercise get _currentExercise =>
      widget.exercises[_currentExerciseIndex];

  List<_SetEntry> get _currentSets =>
      _exerciseSets[_currentExerciseIndex] ?? <_SetEntry>[];

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
    for (int i = 0; i < widget.exercises.length; i++) {
      final RoutineExercise ex = widget.exercises[i];
      _exerciseSets[i] = List<_SetEntry>.generate(
        ex.targetSets,
        (int j) => _SetEntry(
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
    final _SetEntry set = _currentSets[setIndex];
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

    // Start rest timer
    _startRestTimer();
  }

  Future<void> _finishWorkout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Finalizar entreno',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Duración: $_sessionTime\n¿Terminar el entreno?',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      // Capture providers before async gap
      final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
      final PrStreakProvider prProvider = context.read<PrStreakProvider>();
      final int? sessionId = workoutProvider.activeSession?.id;

      // Build completedSets map for PR provider
      final Map<int, List<CompletedSetData>> completedMap =
          <int, List<CompletedSetData>>{};
      for (int i = 0; i < widget.exercises.length; i++) {
        final RoutineExercise ex = widget.exercises[i];
        if (ex.id == null) {
          continue;
        }
        final List<_SetEntry> sets = _exerciseSets[i] ?? <_SetEntry>[];
        completedMap[ex.id!] = sets
            .map(
              (_SetEntry s) => CompletedSetData(
                setNumber: s.setNumber,
                reps: s.reps,
                weight: s.weight,
                completed: s.completed,
              ),
            )
            .toList();
      }

      // Process PR detection, recovery, and streak
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
        final bool? leave = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppTheme.cardDark,
            title: const Text(
              '¿Salir del entreno?',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            content: const Text(
              'Tu progreso actual no se perderá pero el entreno continuará activo.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Salir',
                  style: TextStyle(color: AppTheme.danger),
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
            // Header
            _WorkoutHeader(
              sessionTime: _sessionTime,
              currentIndex: _currentExerciseIndex,
              total: widget.exercises.length,
              onFinish: _finishWorkout,
            ),

            // Rest timer overlay
            if (_isRestTimerActive)
              _RestTimerBanner(
                seconds: _restSeconds,
                onSkip: _skipRest,
              ),

            // Exercise navigation
            _ExerciseNavigation(
              exercises: widget.exercises,
              currentIndex: _currentExerciseIndex,
              onSelect: (int i) =>
                  setState(() => _currentExerciseIndex = i),
            ),

            // Current exercise info
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

            // Sets list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _currentSets.length,
                itemBuilder: (_, int i) => _SetRow(
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

            // Bottom navigation
            _BottomNavBar(
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

class _WorkoutHeader extends StatelessWidget {
  const _WorkoutHeader({
    required this.sessionTime,
    required this.currentIndex,
    required this.total,
    required this.onFinish,
  });
  final String sessionTime;
  final int currentIndex;
  final int total;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Entreno en curso',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.timer_rounded,
                      color: AppTheme.primaryOrange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sessionTime,
                      style: const TextStyle(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${currentIndex + 1}/$total ejercicios',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onFinish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Terminar'),
          ),
        ],
      ),
    );
  }
}

class _RestTimerBanner extends StatelessWidget {
  const _RestTimerBanner({required this.seconds, required this.onSkip});
  final int seconds;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.info.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: AppTheme.info.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.hourglass_bottom_rounded,
            color: AppTheme.info,
            size: 18,
          ),
          const SizedBox(width: 8),
          const Text(
            'Descansando: ',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          Text(
            '${seconds}s',
            style: const TextStyle(
              color: AppTheme.info,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.info,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
            ),
            child: const Text('Saltar'),
          ),
        ],
      ),
    );
  }
}

class _ExerciseNavigation extends StatelessWidget {
  const _ExerciseNavigation({
    required this.exercises,
    required this.currentIndex,
    required this.onSelect,
  });
  final List<RoutineExercise> exercises;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: exercises.length,
        itemBuilder: (_, int i) {
          final bool isSelected = i == currentIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : const Color(0xFF333333),
                ),
              ),
              child: Text(
                exercises[i].exerciseName.split(' ').first,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SetEntry {
  _SetEntry({
    required this.setNumber,
    required this.reps,
    required this.weight,
  }) : completed = false;
  final int setNumber;
  int reps;
  double weight;
  bool completed;
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.entry,
    required this.index,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onComplete,
  });
  final _SetEntry entry;
  final int index;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: entry.completed
            ? AppTheme.success.withValues(alpha: 0.08)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: entry.completed
              ? AppTheme.success.withValues(alpha: 0.3)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Set number
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: entry.completed
                  ? AppTheme.success
                  : AppTheme.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: entry.completed
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  )
                : Text(
                    '${entry.setNumber}',
                    style: const TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Weight
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Peso (kg)',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Row(
                  children: <Widget>[
                    _SmallBtn(
                      icon: Icons.remove_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onWeightChanged(
                                (entry.weight - 2.5).clamp(0, 999),
                              ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entry.weight.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _SmallBtn(
                      icon: Icons.add_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onWeightChanged(
                                (entry.weight + 2.5).clamp(0, 999),
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reps
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Reps',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Row(
                  children: <Widget>[
                    _SmallBtn(
                      icon: Icons.remove_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onRepsChanged(
                                (entry.reps - 1).clamp(1, 100),
                              ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.reps}',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _SmallBtn(
                      icon: Icons.add_rounded,
                      onTap: entry.completed
                          ? null
                          : () => onRepsChanged(
                                (entry.reps + 1).clamp(1, 100),
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Complete button
          GestureDetector(
            onTap: entry.completed ? null : onComplete,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: entry.completed
                    ? AppTheme.success
                    : AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                entry.completed
                    ? Icons.check_rounded
                    : Icons.done_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  const _SmallBtn({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppTheme.primaryOrange.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14,
          color: onTap != null
              ? AppTheme.primaryOrange
              : AppTheme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.canGoBack,
    required this.canGoForward,
    required this.isLast,
    required this.onBack,
    required this.onForward,
    required this.onFinish,
  });
  final bool canGoBack;
  final bool canGoForward;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: <Widget>[
          if (canGoBack)
            OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Anterior'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          const Spacer(),
          if (isLast)
            ElevatedButton.icon(
              onPressed: onFinish,
              icon: const Icon(Icons.emoji_events_rounded, size: 18),
              label: const Text('¡Terminar!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: canGoForward ? onForward : null,
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Siguiente'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
