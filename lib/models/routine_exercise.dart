class RoutineExercise {

  RoutineExercise({
    this.id,
    required this.dayOfWeek,
    this.machineId,
    required this.exerciseName,
    required this.targetSets,
    required this.targetReps,
    required this.targetWeight,
    this.notes = '',
    this.orderIndex = 0,
  });

  factory RoutineExercise.fromMap(Map<String, dynamic> map) {
    return RoutineExercise(
      id: map['id'] as int?,
      dayOfWeek: map['day_of_week'] as int,
      machineId: map['machine_id'] as int?,
      exerciseName: map['exercise_name'] as String,
      targetSets: map['target_sets'] as int,
      targetReps: map['target_reps'] as int,
      targetWeight: (map['target_weight'] as num).toDouble(),
      notes: map['notes'] as String? ?? '',
      orderIndex: map['order_index'] as int? ?? 0,
    );
  }
  final int? id;
  final int dayOfWeek; // 1=Lunes ... 7=Domingo
  final int? machineId;
  final String exerciseName;
  final int targetSets;
  final int targetReps;
  final double targetWeight;
  final String notes;
  final int orderIndex;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'day_of_week': dayOfWeek,
      'machine_id': machineId,
      'exercise_name': exerciseName,
      'target_sets': targetSets,
      'target_reps': targetReps,
      'target_weight': targetWeight,
      'notes': notes,
      'order_index': orderIndex,
    };
  }

  RoutineExercise copyWith({
    int? id,
    int? dayOfWeek,
    int? machineId,
    String? exerciseName,
    int? targetSets,
    int? targetReps,
    double? targetWeight,
    String? notes,
    int? orderIndex,
  }) {
    return RoutineExercise(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      machineId: machineId ?? this.machineId,
      exerciseName: exerciseName ?? this.exerciseName,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      targetWeight: targetWeight ?? this.targetWeight,
      notes: notes ?? this.notes,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

class WorkoutSession {

  WorkoutSession({
    this.id,
    required this.date,
    required this.dayOfWeek,
    this.durationMinutes,
    this.notes = '',
    this.sets = const <WorkoutSet>[],
  });

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      dayOfWeek: map['day_of_week'] as int,
      durationMinutes: map['duration_minutes'] as int?,
      notes: map['notes'] as String? ?? '',
    );
  }
  final int? id;
  final DateTime date;
  final int dayOfWeek;
  final int? durationMinutes;
  final String notes;
  final List<WorkoutSet> sets;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'day_of_week': dayOfWeek,
      'duration_minutes': durationMinutes,
      'notes': notes,
    };
  }
}

class WorkoutSet {

  WorkoutSet({
    this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseName,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.completed = false,
  });

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'] as int?,
      sessionId: map['session_id'] as int,
      exerciseId: map['exercise_id'] as int,
      exerciseName: map['exercise_name'] as String,
      setNumber: map['set_number'] as int,
      reps: map['reps'] as int,
      weight: (map['weight'] as num).toDouble(),
      completed: (map['completed'] as int) == 1,
    );
  }
  final int? id;
  final int sessionId;
  final int exerciseId;
  final String exerciseName;
  final int setNumber;
  final int reps;
  final double weight;
  final bool completed;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'completed': completed ? 1 : 0,
    };
  }

  WorkoutSet copyWith({
    int? id,
    int? sessionId,
    int? exerciseId,
    String? exerciseName,
    int? setNumber,
    int? reps,
    double? weight,
    bool? completed,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      completed: completed ?? this.completed,
    );
  }
}

const List<String> kDayNames = <String>[
  '', // index 0 unused
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];

const List<String> kDayShortNames = <String>[
  '',
  'LUN',
  'MAR',
  'MIÉ',
  'JUE',
  'VIE',
  'SÁB',
  'DOM',
];
