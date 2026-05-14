import 'package:sqflite/sqflite.dart';

import '../../models/machine.dart';

mixin MachineDao {
  Future<Database> get database;

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

  Future<int> getTotalMachines() async {
    final Database db = await database;
    final List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) as count FROM machines');
    return (result.first['count'] as int?) ?? 0;
  }
}
