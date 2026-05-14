// ─── Personal Record ─────────────────────────────────────────────
class PersonalRecord {

  PersonalRecord({
    this.id,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.estimated1rm,
    this.sessionId,
    required this.achievedAt,
  });

  factory PersonalRecord.fromMap(Map<String, dynamic> m) => PersonalRecord(
        id: m['id'] as int?,
        exerciseName: m['exercise_name'] as String,
        weight: (m['weight'] as num).toDouble(),
        reps: m['reps'] as int,
        estimated1rm: (m['estimated_1rm'] as num).toDouble(),
        sessionId: m['session_id'] as int?,
        achievedAt: DateTime.parse(m['achieved_at'] as String),
      );
  final int? id;
  final String exerciseName;
  final double weight;
  final int reps;
  final double estimated1rm;
  final int? sessionId;
  final DateTime achievedAt;

  /// Epley formula: 1RM = w × (1 + r / 30)
  static double calc1rm(double weight, int reps) {
    if (reps == 1) {
      return weight;
    }
    return weight * (1 + reps / 30);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'exercise_name': exerciseName,
        'weight': weight,
        'reps': reps,
        'estimated_1rm': estimated1rm,
        'session_id': sessionId,
        'achieved_at': achievedAt.toIso8601String(),
      };
}

// ─── Achievement ──────────────────────────────────────────────────
class Achievement {

  const Achievement({
    required this.key,
    required this.title,
    required this.description,
    required this.emoji,
    this.unlockedAt,
  });
  final String key;
  final String title;
  final String description;
  final String emoji;
  final DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;

  Achievement copyWith({DateTime? unlockedAt}) => Achievement(
        key: key,
        title: title,
        description: description,
        emoji: emoji,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
}

const List<Achievement> kAllAchievements = <Achievement>[
  Achievement(
    key: 'first_workout',
    title: 'Primera gota de sudor',
    description: 'Completa tu primer entreno',
    emoji: '🏋️',
  ),
  Achievement(
    key: 'workouts_5',
    title: 'Constancia',
    description: '5 entrenos completados',
    emoji: '🔥',
  ),
  Achievement(
    key: 'workouts_10',
    title: 'Disciplina',
    description: '10 entrenos completados',
    emoji: '⚡',
  ),
  Achievement(
    key: 'workouts_25',
    title: 'Guerrero',
    description: '25 entrenos completados',
    emoji: '🦁',
  ),
  Achievement(
    key: 'workouts_50',
    title: 'Bestia del gym',
    description: '50 entrenos completados',
    emoji: '👑',
  ),
  Achievement(
    key: 'first_pr',
    title: 'Primer récord',
    description: 'Establece tu primer PR',
    emoji: '🏆',
  ),
  Achievement(
    key: 'prs_5',
    title: 'Rompe récords',
    description: 'Logra 5 PRs diferentes',
    emoji: '💎',
  ),
  Achievement(
    key: 'streak_3',
    title: '3 días seguidos',
    description: 'Entrena 3 días consecutivos',
    emoji: '🗓️',
  ),
  Achievement(
    key: 'streak_7',
    title: 'Semana perfecta',
    description: 'Entrena 7 días seguidos',
    emoji: '🌟',
  ),
  Achievement(
    key: 'streak_30',
    title: 'Mes de hierro',
    description: 'Entrena 30 días seguidos',
    emoji: '🎖️',
  ),
  Achievement(
    key: 'machines_5',
    title: 'Explorador',
    description: 'Registra 5 máquinas',
    emoji: '🔍',
  ),
  Achievement(
    key: 'machines_10',
    title: 'Conocedor del gym',
    description: 'Registra 10 máquinas',
    emoji: '🎓',
  ),
  Achievement(
    key: 'heavy_100',
    title: 'Triple dígito',
    description: 'Levanta 100kg en cualquier ejercicio',
    emoji: '💯',
  ),
];

// ─── Muscle Recovery ──────────────────────────────────────────────
class MuscleRecoveryEntry { // 1=ligero, 2=moderado, 3=pesado

  MuscleRecoveryEntry({
    this.id,
    required this.muscleName,
    required this.workedAt,
    required this.intensity,
  });

  factory MuscleRecoveryEntry.fromMap(Map<String, dynamic> m) =>
      MuscleRecoveryEntry(
        id: m['id'] as int?,
        muscleName: m['muscle_name'] as String,
        workedAt: DateTime.parse(m['worked_at'] as String),
        intensity: m['intensity'] as int? ?? 2,
      );
  final int? id;
  final String muscleName;
  final DateTime workedAt;
  final int intensity;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'muscle_name': muscleName,
        'worked_at': workedAt.toIso8601String(),
        'intensity': intensity,
      };

  /// Recovery hours based on muscle size + intensity
  Duration get recoveryDuration {
    final int baseHours = kMuscleRecoveryHours[muscleName] ?? 48;
    final double multiplier = intensity == 3
        ? 1.3
        : intensity == 2
            ? 1.0
            : 0.75;
    return Duration(hours: (baseHours * multiplier).round());
  }

  DateTime get recoveredAt => workedAt.add(recoveryDuration);

  /// 0.0 = just worked, 1.0 = fully recovered
  double recoveryPercent(DateTime now) {
    final int total = recoveryDuration.inMinutes;
    final int elapsed = now.difference(workedAt).inMinutes;
    return (elapsed / total).clamp(0.0, 1.0);
  }
}

/// Recovery time in hours per muscle group
const Map<String, int> kMuscleRecoveryHours = <String, int>{
  // Large muscles — 72h
  'Pecho': 72,
  'Espalda': 72,
  'Cuádriceps': 72,
  'Glúteos': 72,
  'Isquiotibiales': 72,
  // Medium muscles — 48h
  'Hombros': 48,
  'Trapecio': 48,
  // Small muscles — 36h
  'Bíceps': 36,
  'Tríceps': 36,
  'Pantorrillas': 36,
  'Abdomen': 36,
  'Antebrazos': 36,
};

/// Map exercise name keywords → muscle groups affected
const Map<String, List<String>> kExerciseMuscleMap = <String, List<String>>{
  'press': <String>['Pecho', 'Tríceps', 'Hombros'],
  'banca': <String>['Pecho', 'Tríceps', 'Hombros'],
  'chest': <String>['Pecho', 'Tríceps'],
  'apertura': <String>['Pecho'],
  'fondos': <String>['Pecho', 'Tríceps'],
  'dominada': <String>['Espalda', 'Bíceps'],
  'jalón': <String>['Espalda', 'Bíceps'],
  'remo': <String>['Espalda', 'Bíceps'],
  'peso muerto': <String>['Espalda', 'Glúteos', 'Isquiotibiales'],
  'sentadilla': <String>['Cuádriceps', 'Glúteos', 'Isquiotibiales'],
  'prensa': <String>['Cuádriceps', 'Glúteos'],
  'extensión': <String>['Cuádriceps'],
  'curl femoral': <String>['Isquiotibiales'],
  'hip thrust': <String>['Glúteos', 'Isquiotibiales'],
  'military': <String>['Hombros', 'Tríceps'],
  'arnold': <String>['Hombros'],
  'elevación': <String>['Hombros'],
  'curl': <String>['Bíceps'],
  'tricep': <String>['Tríceps'],
  'tríceps': <String>['Tríceps'],
  'gemelo': <String>['Pantorrillas'],
  'pantorrilla': <String>['Pantorrillas'],
  'plancha': <String>['Abdomen'],
  'crunch': <String>['Abdomen'],
  'abdominal': <String>['Abdomen'],
};

List<String> musclesForExercise(String exerciseName) {
  final String lower = exerciseName.toLowerCase();
  final Set<String> muscles = <String>{};
  for (final MapEntry<String, List<String>> entry in kExerciseMuscleMap.entries) {
    if (lower.contains(entry.key)) {
      muscles.addAll(entry.value);
    }
  }
  return muscles.toList();
}
