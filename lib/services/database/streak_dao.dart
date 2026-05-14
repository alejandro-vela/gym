import 'package:sqflite/sqflite.dart';

mixin StreakDao {
  Future<Database> get database;

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
