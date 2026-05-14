import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/achievement.dart';
import '../models/body_measurement.dart';
import '../models/machine.dart';
import '../models/routine_exercise.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'gymtrack_pro.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> initDatabase() async {
    await database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE machines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        how_to_use TEXT NOT NULL,
        photo_path TEXT,
        muscle_groups TEXT NOT NULL DEFAULT '',
        difficulty INTEGER NOT NULL DEFAULT 1,
        precautions TEXT NOT NULL DEFAULT '',
        precaution_photo_path TEXT,
        category TEXT NOT NULL DEFAULT 'Fuerza',
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE routine_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day_of_week INTEGER NOT NULL,
        machine_id INTEGER,
        exercise_name TEXT NOT NULL,
        target_sets INTEGER NOT NULL DEFAULT 3,
        target_reps INTEGER NOT NULL DEFAULT 10,
        target_weight REAL NOT NULL DEFAULT 0,
        notes TEXT DEFAULT '',
        order_index INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        day_of_week INTEGER NOT NULL,
        duration_minutes INTEGER,
        notes TEXT DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        set_number INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight REAL NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (session_id) REFERENCES workout_sessions(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE personal_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_name TEXT NOT NULL,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        estimated_1rm REAL NOT NULL,
        session_id INTEGER,
        achieved_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE muscle_recovery_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        muscle_name TEXT NOT NULL,
        worked_at TEXT NOT NULL,
        intensity INTEGER NOT NULL DEFAULT 2
      )
    ''');

    await db.execute('''
      CREATE TABLE achievements_unlocked (
        key TEXT NOT NULL PRIMARY KEY,
        unlocked_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_streak_days (
        date TEXT NOT NULL PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE body_measurements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        weight REAL,
        body_fat_percent REAL,
        chest REAL,
        waist REAL,
        hips REAL,
        left_arm REAL,
        right_arm REAL,
        left_thigh REAL,
        right_thigh REAL,
        notes TEXT DEFAULT ''
      )
    ''');
  }

  // ─── MACHINES ────────────────────────────────────────────────
  Future<int> insertMachine(Machine machine) async {
    final Database db = await database;
    return db.insert('machines', machine.toMap());
  }

  Future<List<Machine>> getAllMachines() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps =
        await db.query('machines', orderBy: 'name ASC');
    return maps.map((Map<String, Object?> m) => Machine.fromMap(m)).toList();
  }

  Future<List<Machine>> getMachinesByCategory(String category) async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'machines',
      where: 'category = ?',
      whereArgs: <Object?>[category],
      orderBy: 'name ASC',
    );
    return maps.map((Map<String, Object?> m) => Machine.fromMap(m)).toList();
  }

  Future<Machine?> getMachineById(int id) async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'machines',
      where: 'id = ?',
      whereArgs: <Object?>[id],
      limit: 1,
    );
    if (maps.isEmpty) {
      return null;
    }
    return Machine.fromMap(maps.first);
  }

  Future<int> updateMachine(Machine machine) async {
    final Database db = await database;
    return db.update(
      'machines',
      machine.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[machine.id],
    );
  }

  Future<int> deleteMachine(int id) async {
    final Database db = await database;
    return db.delete('machines', where: 'id = ?', whereArgs: <Object?>[id]);
  }

  // ─── ROUTINE EXERCISES ───────────────────────────────────────
  Future<int> insertRoutineExercise(RoutineExercise exercise) async {
    final Database db = await database;
    return db.insert('routine_exercises', exercise.toMap());
  }

  Future<List<RoutineExercise>> getExercisesForDay(int dayOfWeek) async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'routine_exercises',
      where: 'day_of_week = ?',
      whereArgs: <Object?>[dayOfWeek],
      orderBy: 'order_index ASC',
    );
    return maps
        .map((Map<String, Object?> m) => RoutineExercise.fromMap(m))
        .toList();
  }

  Future<int> updateRoutineExercise(RoutineExercise exercise) async {
    final Database db = await database;
    return db.update(
      'routine_exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[exercise.id],
    );
  }

  Future<int> deleteRoutineExercise(int id) async {
    final Database db = await database;
    return db
        .delete('routine_exercises', where: 'id = ?', whereArgs: <Object?>[id]);
  }

  // ─── WORKOUT SESSIONS ────────────────────────────────────────
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

  // ─── WORKOUT SETS ────────────────────────────────────────────
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

  Future<int> getTotalMachines() async {
    final Database db = await database;
    final List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) as count FROM machines');
    return (result.first['count'] as int?) ?? 0;
  }

  // ─── BODY MEASUREMENTS ───────────────────────────────────────
  Future<int> insertMeasurement(BodyMeasurement measurement) async {
    final Database db = await database;
    return db.insert('body_measurements', measurement.toMap());
  }

  Future<List<BodyMeasurement>> getAllMeasurements() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps =
        await db.query('body_measurements', orderBy: 'date DESC');
    return maps
        .map((Map<String, Object?> m) => BodyMeasurement.fromMap(m))
        .toList();
  }

  Future<BodyMeasurement?> getLatestMeasurement() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'body_measurements',
      orderBy: 'date DESC',
      limit: 1,
    );
    if (maps.isEmpty) {
      return null;
    }
    return BodyMeasurement.fromMap(maps.first);
  }

  Future<int> deleteMeasurement(int id) async {
    final Database db = await database;
    return db
        .delete('body_measurements', where: 'id = ?', whereArgs: <Object?>[id]);
  }

  // ─── PERSONAL RECORDS ─────────────────────────────────────────
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

  // ─── MUSCLE RECOVERY ──────────────────────────────────────────
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

  // ─── ACHIEVEMENTS ─────────────────────────────────────────────
  Future<void> unlockAchievement(String key) async {
    final Database db = await database;
    await db.insert(
      'achievements_unlocked',
      <String, Object?>{
        'key': key,
        'unlocked_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Set<String>> getUnlockedAchievements() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps =
        await db.query('achievements_unlocked');
    return maps.map((Map<String, Object?> m) => m['key']! as String).toSet();
  }

  // ─── STREAKS ──────────────────────────────────────────────────
  Future<void> recordWorkoutDay(DateTime date) async {
    final Database db = await database;
    final String dateStr = date.toIso8601String().split('T')[0];
    await db.insert(
      'workout_streak_days',
      <String, Object?>{'date': dateStr},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> getCurrentStreak() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'workout_streak_days',
      orderBy: 'date DESC',
    );
    if (maps.isEmpty) {
      return 0;
    }

    final List<DateTime> dates = maps
        .map((Map<String, Object?> m) => DateTime.parse(m['date']! as String))
        .toList();

    int streak = 0;
    DateTime check = DateTime.now();
    // Allow today or yesterday as start
    if (dates.first
            .difference(DateTime(check.year, check.month, check.day))
            .inDays <
        -1) {
      return 0;
    }

    for (final DateTime date in dates) {
      final int diff = DateTime(check.year, check.month, check.day)
          .difference(DateTime(date.year, date.month, date.day))
          .inDays;
      if (diff == 0 || diff == 1) {
        streak++;
        check = date;
      } else {
        break;
      }
    }
    return streak;
  }

  Future<int> getLongestStreak() async {
    final Database db = await database;
    final List<Map<String, Object?>> maps =
        await db.query('workout_streak_days', orderBy: 'date ASC');
    if (maps.isEmpty) {
      return 0;
    }

    int longest = 1;
    int current = 1;
    final List<DateTime> dates = maps
        .map((Map<String, Object?> m) => DateTime.parse(m['date']! as String))
        .toList();

    for (int i = 1; i < dates.length; i++) {
      final int diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) {
          longest = current;
        }
      } else if (diff > 1) {
        current = 1;
      }
    }
    return longest;
  }
}
