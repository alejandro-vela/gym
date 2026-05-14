import 'package:flutter/foundation.dart';

import '../models/body_measurement.dart';
import '../models/routine_exercise.dart';
import '../services/database_service.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutSession? _activeSession;
  Map<int, List<WorkoutSet>> _activeSets =
      <int, List<WorkoutSet>>{}; // exerciseId -> sets
  DateTime? _sessionStart;
  bool _isActive = false;

  WorkoutSession? get activeSession => _activeSession;
  bool get isActive => _isActive;
  DateTime? get sessionStart => _sessionStart;

  Map<int, List<WorkoutSet>> get activeSets => _activeSets;

  List<WorkoutSet> setsForExercise(int exerciseId) =>
      _activeSets[exerciseId] ?? <WorkoutSet>[];

  Future<void> startSession(int dayOfWeek) async {
    final int sessionId = await DatabaseService.instance.insertWorkoutSession(
      WorkoutSession(
        date: DateTime.now(),
        dayOfWeek: dayOfWeek,
      ),
    );
    _activeSession = WorkoutSession(
      id: sessionId,
      date: DateTime.now(),
      dayOfWeek: dayOfWeek,
    );
    _activeSets = <int, List<WorkoutSet>>{};
    _sessionStart = DateTime.now();
    _isActive = true;
    notifyListeners();
  }

  Future<void> endSession() async {
    if (_activeSession == null || _sessionStart == null) {
      return;
    }
    final int minutes =
        DateTime.now().difference(_sessionStart!).inMinutes;
    await DatabaseService.instance.updateSessionDuration(
      _activeSession!.id!,
      minutes,
    );
    _activeSession = null;
    _activeSets = <int, List<WorkoutSet>>{};
    _sessionStart = null;
    _isActive = false;
    notifyListeners();
  }

  Future<void> logSet({
    required RoutineExercise exercise,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    if (_activeSession == null) {
      return;
    }

    final WorkoutSet set = WorkoutSet(
      sessionId: _activeSession!.id!,
      exerciseId: exercise.id!,
      exerciseName: exercise.exerciseName,
      setNumber: setNumber,
      reps: reps,
      weight: weight,
      completed: true,
    );

    final int id = await DatabaseService.instance.insertWorkoutSet(set);
    final WorkoutSet newSet = set.copyWith(id: id);

    _activeSets[exercise.id!] ??= <WorkoutSet>[];
    final int existing = _activeSets[exercise.id!]!
        .indexWhere((WorkoutSet s) => s.setNumber == setNumber);
    if (existing != -1) {
      _activeSets[exercise.id!]![existing] = newSet;
    } else {
      _activeSets[exercise.id!]!.add(newSet);
    }
    notifyListeners();
  }

  int completedSetsCount(int exerciseId) {
    return _activeSets[exerciseId]
            ?.where((WorkoutSet s) => s.completed)
            .length ??
        0;
  }
}

class ProgressProvider extends ChangeNotifier {
  List<BodyMeasurement> _measurements = <BodyMeasurement>[];
  List<WorkoutSession> _sessions = <WorkoutSession>[];
  Map<String, double> _maxWeights = <String, double>{};
  bool _isLoading = false;

  List<BodyMeasurement> get measurements => _measurements;
  List<WorkoutSession> get sessions => _sessions;
  Map<String, double> get maxWeights => _maxWeights;
  bool get isLoading => _isLoading;
  BodyMeasurement? get latestMeasurement =>
      _measurements.isNotEmpty ? _measurements.first : null;

  Future<void> loadProgress() async {
    _isLoading = true;
    notifyListeners();
    _measurements = await DatabaseService.instance.getAllMeasurements();
    _sessions = await DatabaseService.instance.getAllSessions();
    _maxWeights = await DatabaseService.instance.getExerciseMaxWeights();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMeasurement(BodyMeasurement measurement) async {
    final int id =
        await DatabaseService.instance.insertMeasurement(measurement);
    _measurements.insert(
      0,
      BodyMeasurement.fromMap(
        <String, dynamic>{...measurement.toMap(), 'id': id},
      ),
    );
    notifyListeners();
  }

  Future<void> deleteMeasurement(int id) async {
    await DatabaseService.instance.deleteMeasurement(id);
    _measurements.removeWhere((BodyMeasurement m) => m.id == id);
    notifyListeners();
  }

  int get totalWorkouts => _sessions.length;

  int get totalMinutes => _sessions.fold(
        0,
        (int sum, WorkoutSession s) => sum + (s.durationMinutes ?? 0),
      );
}
