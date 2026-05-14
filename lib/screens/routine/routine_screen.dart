import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/routine_exercise.dart';
import '../../providers/routine_provider.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';
import 'add_exercise_screen.dart';
import 'widgets/day_selector.dart';
import 'widgets/routine_exercise_card.dart';
import 'widgets/routine_summary_card.dart';
import 'workout_session_screen.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoutineProvider routineProvider = context.watch<RoutineProvider>();
    final RoutineStrings s = context.watch<LanguageProvider>().strings.routine;
    final int today = DateTime.now().weekday;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.title),
      ),
      body: Column(
        children: <Widget>[
          DaySelector(
            selectedDay: routineProvider.selectedDay,
            todayDay: today,
            onDaySelected: routineProvider.selectDay,
            strings: s,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Consumer<RoutineProvider>(
              builder: (BuildContext context, RoutineProvider provider, _) {
                final List<RoutineExercise> exercises =
                    provider.exercisesForDay(provider.selectedDay);
                if (exercises.isEmpty) {
                  return _EmptyDayState(
                    dayName: s.dayName(provider.selectedDay),
                    emptyBody: s.emptyDayBody,
                    addLabel: s.addExercise,
                    onAdd: () =>
                        _addExercise(context, provider.selectedDay),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: <Widget>[
                    RoutineSummaryCard(
                      exercises: exercises,
                      isToday: provider.selectedDay == today,
                      onStartWorkout: () => _startWorkout(
                        context,
                        provider.selectedDay,
                        exercises,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...exercises.asMap().entries.map(
                          (MapEntry<int, RoutineExercise> e) =>
                              RoutineExerciseCard(
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
        label: Text(s.addExercise),
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

class _EmptyDayState extends StatelessWidget {
  const _EmptyDayState({
    required this.dayName,
    required this.emptyBody,
    required this.addLabel,
    required this.onAdd,
  });
  final String dayName;
  final String emptyBody;
  final String addLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final RoutineStrings s = context.read<LanguageProvider>().strings.routine;
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
            s.emptyTitle(dayName),
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            emptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: Text(addLabel),
          ),
        ],
      ),
    );
  }
}
