import 'package:flutter/foundation.dart';

import '../models/achievement.dart';
import '../models/routine_exercise.dart';
import '../services/database_service.dart';
import '../services/progressive_overload_service.dart';

class PrStreakProvider extends ChangeNotifier {
  List<PersonalRecord> _allPrs = <PersonalRecord>[];
  Set<String> _unlockedAchievements = <String>{};
  int _currentStreak = 0;
  int _longestStreak = 0;
  bool _isLoading = false;

  // In-session new PR detection
  PersonalRecord? _latestNewPr;

  List<PersonalRecord> get allPrs => _allPrs;
  Set<String> get unlockedAchievements => _unlockedAchievements;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  bool get isLoading => _isLoading;
  PersonalRecord? get latestNewPr => _latestNewPr;

  List<Achievement> get achievements => kAllAchievements
      .map(
        (Achievement a) => _unlockedAchievements.contains(a.key)
            ? a.copyWith(unlockedAt: DateTime.now())
            : a,
      )
      .toList();

  List<Achievement> get unlockedList =>
      achievements.where((Achievement a) => a.isUnlocked).toList();

  /// Best PR (by 1RM) per exercise name
  Map<String, PersonalRecord> get bestPrByExercise {
    final Map<String, PersonalRecord> map = <String, PersonalRecord>{};
    for (final PersonalRecord pr in _allPrs) {
      if (!map.containsKey(pr.exerciseName) ||
          pr.estimated1rm > map[pr.exerciseName]!.estimated1rm) {
        map[pr.exerciseName] = pr;
      }
    }
    return map;
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();

    _allPrs = await DatabaseService.instance.getAllPersonalRecords();
    _unlockedAchievements =
        await DatabaseService.instance.getUnlockedAchievements();
    _currentStreak = await DatabaseService.instance.getCurrentStreak();
    _longestStreak = await DatabaseService.instance.getLongestStreak();

    _isLoading = false;
    notifyListeners();
  }

  /// Called at the end of a workout session.
  /// Processes all completed sets for PR detection, recovery logging, and streak.
  Future<void> processCompletedSession({
    required int sessionId,
    required List<RoutineExercise> exercises,
    required Map<int, List<CompletedSetData>> completedSetsByExerciseId,
    required int dayOfWeek,
  }) async {
    // 1. Record streak day
    await DatabaseService.instance.recordWorkoutDay(DateTime.now());
    _currentStreak = await DatabaseService.instance.getCurrentStreak();
    _longestStreak = await DatabaseService.instance.getLongestStreak();

    // 2. Detect PRs
    PersonalRecord? newestPr;
    for (final RoutineExercise exercise in exercises) {
      if (exercise.id == null) {
        continue;
      }
      final List<CompletedSetData> sets =
          completedSetsByExerciseId[exercise.id] ?? <CompletedSetData>[];
      if (sets.isEmpty) {
        continue;
      }

      for (final CompletedSetData s in sets) {
        if (!s.completed || s.reps <= 0) {
          continue;
        }
        final double new1rm = PersonalRecord.calc1rm(s.weight, s.reps);
        final PersonalRecord? existing = await DatabaseService.instance
            .getBestPrForExercise(exercise.exerciseName);

        if (existing == null || new1rm > existing.estimated1rm + 0.1) {
          final PersonalRecord pr = PersonalRecord(
            exerciseName: exercise.exerciseName,
            weight: s.weight,
            reps: s.reps,
            estimated1rm: new1rm,
            sessionId: sessionId,
            achievedAt: DateTime.now(),
          );
          await DatabaseService.instance.insertPersonalRecord(pr);
          newestPr = pr;
        }
      }
    }

    // 3. Log muscle recovery
    final List<MuscleRecoveryEntry> muscleEntries = <MuscleRecoveryEntry>[];
    for (final RoutineExercise exercise in exercises) {
      if (exercise.id == null) {
        continue;
      }
      final List<CompletedSetData> sets =
          completedSetsByExerciseId[exercise.id] ?? <CompletedSetData>[];
      if (sets.isEmpty) {
        continue;
      }

      final int completedSets =
          sets.where((CompletedSetData s) => s.completed).length;
      if (completedSets == 0) {
        continue;
      }

      final int intensity = exercise.targetWeight >= 80
          ? 3
          : exercise.targetWeight >= 40
              ? 2
              : 1;

      final List<String> muscles = musclesForExercise(exercise.exerciseName);
      for (final String muscle in muscles) {
        muscleEntries.add(
          MuscleRecoveryEntry(
            muscleName: muscle,
            workedAt: DateTime.now(),
            intensity: intensity,
          ),
        );
      }
    }
    if (muscleEntries.isNotEmpty) {
      await DatabaseService.instance.logMuscleRecovery(muscleEntries);
    }

    // 4. Check & unlock achievements
    await _checkAchievements();

    // 5. Refresh state
    _allPrs = await DatabaseService.instance.getAllPersonalRecords();
    _latestNewPr = newestPr;
    notifyListeners();
  }

  Future<void> _checkAchievements() async {
    final int totalWorkouts =
        await DatabaseService.instance.getTotalWorkouts();
    final int totalPrs = await DatabaseService.instance.getTotalPrCount();
    final int totalMachines =
        await DatabaseService.instance.getTotalMachines();
    final int streak = _currentStreak;

    final List<String> toUnlock = <String>[];

    if (totalWorkouts >= 1) {
      toUnlock.add('first_workout');
    }
    if (totalWorkouts >= 5) {
      toUnlock.add('workouts_5');
    }
    if (totalWorkouts >= 10) {
      toUnlock.add('workouts_10');
    }
    if (totalWorkouts >= 25) {
      toUnlock.add('workouts_25');
    }
    if (totalWorkouts >= 50) {
      toUnlock.add('workouts_50');
    }
    if (totalPrs >= 1) {
      toUnlock.add('first_pr');
    }
    if (totalPrs >= 5) {
      toUnlock.add('prs_5');
    }
    if (streak >= 3) {
      toUnlock.add('streak_3');
    }
    if (streak >= 7) {
      toUnlock.add('streak_7');
    }
    if (streak >= 30) {
      toUnlock.add('streak_30');
    }
    if (totalMachines >= 5) {
      toUnlock.add('machines_5');
    }
    if (totalMachines >= 10) {
      toUnlock.add('machines_10');
    }

    // Check for 100kg lift
    final Map<String, double> maxWeights =
        await DatabaseService.instance.getExerciseMaxWeights();
    if (maxWeights.values.any((double w) => w >= 100)) {
      toUnlock.add('heavy_100');
    }

    for (final String key in toUnlock) {
      if (!_unlockedAchievements.contains(key)) {
        await DatabaseService.instance.unlockAchievement(key);
        _unlockedAchievements.add(key);
      }
    }
  }

  void clearLatestPr() {
    _latestNewPr = null;
    notifyListeners();
  }
}

// ─── Recovery Provider ────────────────────────────────────────────
class RecoveryProvider extends ChangeNotifier {
  /// muscle name → latest recovery entry (last time it was worked)
  Map<String, MuscleRecoveryEntry> _latestByMuscle =
      <String, MuscleRecoveryEntry>{};
  bool _isLoading = false;

  Map<String, MuscleRecoveryEntry> get latestByMuscle => _latestByMuscle;
  bool get isLoading => _isLoading;

  /// Recovery status for a muscle at [now]
  MuscleStatus statusFor(String muscle, [DateTime? now]) {
    final MuscleRecoveryEntry? entry = _latestByMuscle[muscle];
    if (entry == null) {
      return MuscleStatus.fresh;
    }
    final double pct = entry.recoveryPercent(now ?? DateTime.now());
    if (pct >= 1.0) {
      return MuscleStatus.fresh;
    }
    if (pct >= 0.5) {
      return MuscleStatus.recovering;
    }
    return MuscleStatus.fatigued;
  }

  double recoveryPercentFor(String muscle, [DateTime? now]) {
    final MuscleRecoveryEntry? entry = _latestByMuscle[muscle];
    if (entry == null) {
      return 1.0;
    }
    return entry.recoveryPercent(now ?? DateTime.now());
  }

  Future<void> loadRecovery() async {
    _isLoading = true;
    notifyListeners();

    final List<MuscleRecoveryEntry> entries =
        await DatabaseService.instance.getRecentMuscleRecovery();
    // Keep only the most recent entry per muscle
    _latestByMuscle = <String, MuscleRecoveryEntry>{};
    for (final MuscleRecoveryEntry e in entries) {
      if (!_latestByMuscle.containsKey(e.muscleName) ||
          e.workedAt.isAfter(_latestByMuscle[e.muscleName]!.workedAt)) {
        _latestByMuscle[e.muscleName] = e;
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}

enum MuscleStatus { fresh, recovering, fatigued }
