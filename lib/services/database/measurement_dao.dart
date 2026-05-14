import 'package:sqflite/sqflite.dart';

import '../../models/body_measurement.dart';

mixin MeasurementDao {
  Future<Database> get database;

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
}
