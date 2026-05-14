import 'package:sqflite/sqflite.dart';

import '../../models/routine_exercise.dart';

mixin RoutineDao {
  Future<Database> get database;

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
}
