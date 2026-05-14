import 'package:sqflite/sqflite.dart';

import '../../models/achievement.dart';
import '../../models/routine_exercise.dart';

mixin WorkoutDao {
  Future<Database> get database;

  Future<int> insertWorkoutSession(WorkoutSession session) async {
    final Database db = await database;
    return db.insert('workout_sessions', session.toMap());
  }

  Future<List<WorkoutSession>> getAllSessions() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps =
        await db.query('workout_sessions', orderBy: 'date DESC');
    return maps
        .map((Map<String, Object?> m) => WorkoutSession.fromMap(m))
        .toList();
  }

  Future<int> updateSessionDuration(int sessionId, int minutes) async {
    final Database db = await database;
    return db.update(
      'workout_sessions',
      <String, Object?>{'duration_minutes': minutes},
      where: 'id = ?',
      whereArgs: <Object?>[sessionId],
    );
  }

  Future<int> insertWorkoutSet(WorkoutSet set) async {
    final Database db = await database;
    return db.insert('workout_sets', set.toMap());
  }

  Future<List<WorkoutSet>> getSetsForSession(int sessionId) async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'workout_sets',
      where: 'session_id = ?',
      whereArgs: <Object?>[sessionId],
      orderBy: 'exercise_id ASC, set_number ASC',
    );
    return maps.map((Map<String, Object?> m) => WorkoutSet.fromMap(m)).toList();
  }

  Future<int> updateWorkoutSet(WorkoutSet set) async {
    final Database db = await database;
    return db.update(
      'workout_sets',
      set.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[set.id],
    );
  }

  Future<Map<String, double>> getExerciseMaxWeights() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.rawQuery('''
      SELECT exercise_name, MAX(weight) as max_weight
      FROM workout_sets
      WHERE completed = 1
      GROUP BY exercise_name
    ''');
    return <String, double>{
      for (final Map<String, Object?> m in maps)
        m['exercise_name']! as String: (m['max_weight']! as num).toDouble(),
    };
  }

  Future<int> getTotalWorkouts() async {
    final Database db = await database;
    final List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) as count FROM workout_sessions');
    return (result.first['count'] as int?) ?? 0;
  }

  Future<void> logMuscleRecovery(List<MuscleRecoveryEntry> entries) async {
    final Database db = await database;
    final Batch batch = db.batch();
    for (final MuscleRecoveryEntry e in entries) {
      batch.insert('muscle_recovery_log', e.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<MuscleRecoveryEntry>> getRecentMuscleRecovery() async {
    final Database db = await database;
    final DateTime cutoff = DateTime.now().subtract(const Duration(days: 7));
    final List<Map<String, Object?>> maps = await db.query(
      'muscle_recovery_log',
      where: 'worked_at > ?',
      whereArgs: <Object?>[cutoff.toIso8601String()],
      orderBy: 'worked_at DESC',
    );
    return maps
        .map((Map<String, Object?> m) => MuscleRecoveryEntry.fromMap(m))
        .toList();
  }

  Future<int> insertPersonalRecord(PersonalRecord pr) async {
    final Database db = await database;
    return db.insert('personal_records', pr.toMap());
  }

  Future<List<PersonalRecord>> getAllPersonalRecords() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps =
        await db.query('personal_records', orderBy: 'achieved_at DESC');
    return maps
        .map((Map<String, Object?> m) => PersonalRecord.fromMap(m))
        .toList();
  }

  Future<PersonalRecord?> getBestPrForExercise(String exerciseName) async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'personal_records',
      where: 'exercise_name = ?',
      whereArgs: <Object?>[exerciseName],
      orderBy: 'estimated_1rm DESC',
      limit: 1,
    );
    if (maps.isEmpty) {
      return null;
    }
    return PersonalRecord.fromMap(maps.first);
  }

  Future<List<PersonalRecord>> getPrHistoryForExercise(
    String exerciseName,
  ) async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'personal_records',
      where: 'exercise_name = ?',
      whereArgs: <Object?>[exerciseName],
      orderBy: 'achieved_at ASC',
    );
    return maps
        .map((Map<String, Object?> m) => PersonalRecord.fromMap(m))
        .toList();
  }

  Future<int> getTotalPrCount() async {
    final Database db = await database;
    final List<Map<String, Object?>> result = await db.rawQuery(
      'SELECT COUNT(DISTINCT exercise_name) as count FROM personal_records',
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
