import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database/machine_dao.dart';
import 'database/measurement_dao.dart';
import 'database/routine_dao.dart';
import 'database/streak_dao.dart';
import 'database/workout_dao.dart';

export 'database/machine_dao.dart';
export 'database/measurement_dao.dart';
export 'database/routine_dao.dart';
export 'database/streak_dao.dart';
export 'database/workout_dao.dart';

class DatabaseService
    with MachineDao, RoutineDao, WorkoutDao, MeasurementDao, StreakDao {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  @override
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
}
