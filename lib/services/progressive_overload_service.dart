import '../models/achievement.dart';
import '../models/routine_exercise.dart';
import 'database_service.dart';

class ProgressiveOverloadSuggestion {
  const ProgressiveOverloadSuggestion({
    required this.exerciseName,
    required this.currentWeight,
    required this.suggestedWeight,
    required this.weightIncrease,
    required this.reason,
    required this.estimated1rm,
  });
  final String exerciseName;
  final double currentWeight;
  final double suggestedWeight;
  final double weightIncrease;
  final String reason;
  final double estimated1rm;
}

class ProgressiveOverloadService {
  ProgressiveOverloadService._();
  static final ProgressiveOverloadService instance =
      ProgressiveOverloadService._();

  static const double _smallIncrement = 2.5; // kg for isolation
  static const double _bigIncrement = 5.0; // kg for compound

  /// True if the exercise is compound (bigger weight increments)
  bool _isCompound(String name) {
    final String lower = name.toLowerCase();
    return lower.contains('sentadilla') ||
        lower.contains('peso muerto') ||
        lower.contains('press banca') ||
        lower.contains('press militar') ||
        lower.contains('remo con barra') ||
        lower.contains('dominada') ||
        lower.contains('prensa');
  }

  double _increment(String name) =>
      _isCompound(name) ? _bigIncrement : _smallIncrement;

  /// Analyse completed sets for one exercise and determine if the user
  /// should increase weight next session.
  ///
  /// Returns a suggestion if ready to progress, null otherwise.
  ProgressiveOverloadSuggestion? analyzeExercise({
    required RoutineExercise exercise,
    required List<CompletedSetData> completedSets,
  }) {
    if (completedSets.isEmpty) {
      return null;
    }

    final int targetSets = exercise.targetSets;
    final int targetReps = exercise.targetReps;
    final double targetWeight = exercise.targetWeight;

    // Only suggest overload if ALL sets were done
    final int fullSets = completedSets
        .where(
          (CompletedSetData s) =>
              s.reps >= targetReps && s.weight >= targetWeight,
        )
        .length;

    final double bestWeight = completedSets.fold(
      0.0,
      (double max, CompletedSetData s) => s.weight > max ? s.weight : max,
    );

    final double best1rm = completedSets.fold(
      0.0,
      (double max, CompletedSetData s) {
        final double rm = PersonalRecord.calc1rm(s.weight, s.reps);
        return rm > max ? rm : max;
      },
    );

    if (fullSets >= targetSets) {
      // All sets completed at target → suggest increase
      final double increase = _increment(exercise.exerciseName);
      return ProgressiveOverloadSuggestion(
        exerciseName: exercise.exerciseName,
        currentWeight: bestWeight,
        suggestedWeight: bestWeight + increase,
        weightIncrease: increase,
        reason:
            '¡Completaste todas las series! Intenta +${increase}kg la próxima vez.',
        estimated1rm: best1rm,
      );
    } else if (fullSets >= (targetSets * 0.8).round()) {
      // 80%+ sets done → keep same weight
      return ProgressiveOverloadSuggestion(
        exerciseName: exercise.exerciseName,
        currentWeight: bestWeight,
        suggestedWeight: bestWeight,
        weightIncrease: 0,
        reason:
            'Mantén el mismo peso y enfócate en completar todas las series.',
        estimated1rm: best1rm,
      );
    }
    // Less than 80% → maybe reduce
    return null;
  }

  /// Calculate estimated 1RM using Epley formula
  double calc1rm(double weight, int reps) =>
      PersonalRecord.calc1rm(weight, reps);

  /// Returns suggested weight for next session based on history
  Future<double?> getSuggestedWeight(String exerciseName) async {
    final PersonalRecord? pr =
        await DatabaseService.instance.getBestPrForExercise(exerciseName);
    if (pr == null) {
      return null;
    }
    // Suggest 75% of 1RM as working weight (safe default)
    return (pr.estimated1rm * 0.75 / 2.5).round() * 2.5;
  }
}

/// Lightweight data class for completed sets analysis
class CompletedSetData {
  const CompletedSetData({
    required this.setNumber,
    required this.reps,
    required this.weight,
    required this.completed,
  });
  final int setNumber;
  final int reps;
  final double weight;
  final bool completed;
}
