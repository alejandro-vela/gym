import 'package:flutter/foundation.dart';

import '../models/routine_exercise.dart';
import '../services/database_service.dart';

class RoutineProvider extends ChangeNotifier {
  final Map<int, List<RoutineExercise>> _exercisesByDay =
      <int, List<RoutineExercise>>{};
  int _selectedDay = DateTime.now().weekday; // 1=Monday
  bool _isLoading = false;

  Map<int, List<RoutineExercise>> get exercisesByDay => _exercisesByDay;
  int get selectedDay => _selectedDay;
  bool get isLoading => _isLoading;

  List<RoutineExercise> get todayExercises =>
      _exercisesByDay[_selectedDay] ?? <RoutineExercise>[];

  List<RoutineExercise> exercisesForDay(int day) =>
      _exercisesByDay[day] ?? <RoutineExercise>[];

  Future<void> loadAllDays() async {
    _isLoading = true;
    notifyListeners();
    for (int day = 1; day <= 7; day++) {
      _exercisesByDay[day] =
          await DatabaseService.instance.getExercisesForDay(day);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExercise(RoutineExercise exercise) async {
    final int id =
        await DatabaseService.instance.insertRoutineExercise(exercise);
    final int day = exercise.dayOfWeek;
    _exercisesByDay[day] ??= <RoutineExercise>[];
    _exercisesByDay[day]!.add(exercise.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateExercise(RoutineExercise exercise) async {
    await DatabaseService.instance.updateRoutineExercise(exercise);
    final int day = exercise.dayOfWeek;
    final List<RoutineExercise> list =
        _exercisesByDay[day] ?? <RoutineExercise>[];
    final int idx =
        list.indexWhere((RoutineExercise e) => e.id == exercise.id);
    if (idx != -1) {
      list[idx] = exercise;
      notifyListeners();
    }
  }

  Future<void> deleteExercise(RoutineExercise exercise) async {
    await DatabaseService.instance.deleteRoutineExercise(exercise.id!);
    _exercisesByDay[exercise.dayOfWeek]
        ?.removeWhere((RoutineExercise e) => e.id == exercise.id);
    notifyListeners();
  }

  void selectDay(int day) {
    _selectedDay = day;
    notifyListeners();
  }
}
