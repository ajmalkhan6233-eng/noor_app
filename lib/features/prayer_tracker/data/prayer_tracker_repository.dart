// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file may touch SQL for the prayer/fasting tracker. Dates
// are stored as plain "YYYY-MM-DD" keys (no time component) since a
// prayer or fast is completed for a calendar day, not an instant.

import 'package:sqflite_sqlcipher/sqflite.dart' show ConflictAlgorithm;

import '../../../core/database/database_helper.dart';

/// The five daily prayers, in their canonical order.
const List<String> trackedPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

class PrayerTrackerRepository {
  PrayerTrackerRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<void> setPrayerCompleted(
    DateTime date,
    String prayer, {
    required bool completed,
  }) async {
    final db = await _dbHelper.database;
    final key = _dateKey(date);
    if (completed) {
      await db.insert(
        'prayer_completions',
        {'date': key, 'prayer': prayer},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      await db.delete(
        'prayer_completions',
        where: 'date = ? AND prayer = ?',
        whereArgs: [key, prayer],
      );
    }
  }

  Future<Set<String>> completedPrayersOn(DateTime date) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'prayer_completions',
      where: 'date = ?',
      whereArgs: [_dateKey(date)],
    );
    return rows.map((row) => row['prayer']! as String).toSet();
  }

  Future<void> setFastingDay(DateTime date, {required bool fasted}) async {
    final db = await _dbHelper.database;
    final key = _dateKey(date);
    if (fasted) {
      await db.insert(
        'fasting_days',
        {'date': key},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      await db.delete('fasting_days', where: 'date = ?', whereArgs: [key]);
    }
  }

  Future<bool> isFastingDay(DateTime date) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'fasting_days',
      where: 'date = ?',
      whereArgs: [_dateKey(date)],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  /// Consecutive days up to and including [date] with all five prayers
  /// completed, walking backwards day by day until one breaks the chain.
  /// One grouped query, then the walk happens in memory.
  Future<int> currentPrayerStreak(DateTime date) async {
    final counts = await completionCountsByDay();
    var streak = 0;
    var day = DateTime(date.year, date.month, date.day);
    while ((counts[day] ?? 0) >= trackedPrayers.length) {
      streak++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return streak;
  }

  /// Consecutive fasted days up to and including [date].
  Future<int> currentFastingStreak(DateTime date) async {
    final fasted = await fastingDates();
    var streak = 0;
    var day = DateTime(date.year, date.month, date.day);
    while (fasted.contains(day)) {
      streak++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return streak;
  }

  /// Every day marked as fasted, as date-only values.
  Future<Set<DateTime>> fastingDates() async {
    final db = await _dbHelper.database;
    final rows = await db.query('fasting_days', columns: ['date']);
    return rows.map((row) => _parseKey(row['date']! as String)).whereType<DateTime>().toSet();
  }

  /// One entry per day from [start] to [end] inclusive (both dates
  /// truncated to midnight), oldest first — backs the local Progress
  /// screen's weekly/monthly view. Purely local reads of data already
  /// collected by the tracker; nothing here is a new data source.
  Future<List<({DateTime date, int completedCount, bool fasted})>> historyForRange(
    DateTime start,
    DateTime end,
  ) async {
    final counts = await completionCountsByDay();
    final fasted = await fastingDates();
    final results = <({DateTime date, int completedCount, bool fasted})>[];
    var day = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    while (!day.isAfter(last)) {
      results.add((
        date: day,
        completedCount: counts[day] ?? 0,
        fasted: fasted.contains(day),
      ));
      day = DateTime(day.year, day.month, day.day + 1);
    }
    return results;
  }

  /// Completed-prayer count for every day that has at least one tick,
  /// in a single grouped query - backs the Progress card's best-streak
  /// and weekly numbers without one query per day.
  Future<Map<DateTime, int>> completionCountsByDay() async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery(
      'SELECT date, COUNT(*) AS n FROM prayer_completions GROUP BY date',
    );
    final counts = <DateTime, int>{};
    for (final row in rows) {
      final day = _parseKey(row['date']! as String);
      if (day != null) counts[day] = row['n']! as int;
    }
    return counts;
  }

  static DateTime? _parseKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return null;
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  static String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
