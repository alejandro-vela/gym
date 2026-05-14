import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/routine_exercise.dart';
import '../../providers/routine_provider.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';
import 'add_exercise_screen.dart';
import 'workout_session_screen.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoutineProvider routineProvider = context.watch<RoutineProvider>();
    final int today = DateTime.now().weekday;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Rutina'),
      ),
      body: Column(
        children: <Widget>[
          // Day selector
          _DaySelector(
            selectedDay: routineProvider.selectedDay,
            todayDay: today,
            onDaySelected: routineProvider.selectDay,
          ),
          const SizedBox(height: 4),

          // Exercise list
          Expanded(
            child: Consumer<RoutineProvider>(
              builder: (BuildContext context, RoutineProvider provider, _) {
                final List<RoutineExercise> exercises =
                    provider.exercisesForDay(provider.selectedDay);
                if (exercises.isEmpty) {
                  return _EmptyDayState(
                    day: provider.selectedDay,
                    onAdd: () =>
                        _addExercise(context, provider.selectedDay),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: <Widget>[
                    // Day summary
                    _DaySummaryCard(
                      exercises: exercises,
                      isToday: provider.selectedDay == today,
                      onStartWorkout: () => _startWorkout(
                        context,
                        provider.selectedDay,
                        exercises,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Exercises
                    ...exercises.asMap().entries.map(
                          (MapEntry<int, RoutineExercise> e) =>
                              _ExerciseCard(
                            exercise: e.value,
                            index: e.key,
                            onEdit: () => unawaited(
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => AddExerciseScreen(
                                    dayOfWeek: provider.selectedDay,
                                    exercise: e.value,
                                  ),
                                ),
                              ),
                            ),
                            onDelete: () =>
                                unawaited(provider.deleteExercise(e.value)),
                          ),
                        ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _addExercise(context, routineProvider.selectedDay),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Agregar ejercicio'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  void _addExercise(BuildContext context, int day) {
    unawaited(
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => AddExerciseScreen(dayOfWeek: day),
        ),
      ),
    );
  }

  Future<void> _startWorkout(
    BuildContext context,
    int day,
    List<RoutineExercise> exercises,
  ) async {
    final WorkoutProvider workoutProvider = context.read<WorkoutProvider>();
    if (!workoutProvider.isActive) {
      await workoutProvider.startSession(day);
    }
    if (context.mounted) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => WorkoutSessionScreen(
              dayOfWeek: day,
              exercises: exercises,
            ),
          ),
        ),
      );
    }
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector({
    required this.selectedDay,
    required this.todayDay,
    required this.onDaySelected,
  });
  final int selectedDay;
  final int todayDay;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceDark,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<Widget>.generate(7, (int i) {
          final int day = i + 1;
          final bool isSelected = day == selectedDay;
          final bool isToday = day == todayDay;

          return GestureDetector(
            onTap: () => onDaySelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 54,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : isToday
                        ? AppTheme.primaryOrange.withValues(alpha: 0.15)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.5),
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    kDayShortNames[day],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (isToday)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DaySummaryCard extends StatelessWidget {
  const _DaySummaryCard({
    required this.exercises,
    required this.isToday,
    required this.onStartWorkout,
  });
  final List<RoutineExercise> exercises;
  final bool isToday;
  final VoidCallback onStartWorkout;

  @override
  Widget build(BuildContext context) {
    final int totalSets = exercises.fold(
      0,
      (int sum, RoutineExercise e) => sum + e.targetSets,
    );
    final int totalReps = exercises.fold(
      0,
      (int sum, RoutineExercise e) => sum + (e.targetSets * e.targetReps),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppTheme.primaryOrange.withValues(alpha: 0.15),
            AppTheme.primaryOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${exercises.length} ejercicios',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$totalSets series · ~$totalReps repeticiones totales',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isToday)
            ElevatedButton.icon(
              onPressed: onStartWorkout,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Entrenar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                textStyle: const TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });
  final RoutineExercise exercise;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('ex_${exercise.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.danger.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_rounded, color: AppTheme.danger),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: AppTheme.primaryOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      exercise.exerciseName,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        _PillTag(
                          label: '${exercise.targetSets} series',
                          color: AppTheme.primaryOrange,
                        ),
                        const SizedBox(width: 6),
                        _PillTag(
                          label: '${exercise.targetReps} reps',
                          color: AppTheme.info,
                        ),
                        const SizedBox(width: 6),
                        _PillTag(
                          label: '${exercise.targetWeight}kg',
                          color: AppTheme.success,
                        ),
                      ],
                    ),
                    if (exercise.notes.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        exercise.notes,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillTag extends StatelessWidget {
  const _PillTag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyDayState extends StatelessWidget {
  const _EmptyDayState({required this.day, required this.onAdd});
  final int day;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.hotel_rounded,
              color: AppTheme.textSecondary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${kDayNames[day]} libre',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sin ejercicios para este día.\nAgrega tu rutina 💪',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agregar ejercicio'),
          ),
        ],
      ),
    );
  }
}
