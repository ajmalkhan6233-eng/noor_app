// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file may touch SQL for the prayer/fasting tracker. Dates
// are stored as plain "YYYY-MM-DD" keys (no time component) since a
// prayer or fast is completed for a calendar day, not an instant.

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
      await db.insert('prayer_completions', {'date': key, 'prayer': prayer});
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
      await db.insert('fasting_days', {'date': key});
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
  Future<int> currentPrayerStreak(DateTime date) async {
    var streak = 0;
    var day = date;
    while (true) {
      final completed = await completedPrayersOn(day);
      if (!trackedPrayers.every(completed.contains)) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Consecutive fasted days up to and including [date].
  Future<int> currentFastingStreak(DateTime date) async {
    var streak = 0;
    var day = date;
    while (true) {
      if (!await isFastingDay(day)) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// One entry per day from [start] to [end] inclusive (both dates
  /// truncated to midnight), oldest first — backs the local Progress
  /// screen's weekly/monthly view. Purely local reads of data already
  /// collected by the tracker; nothing here is a new data source.
  Future<List<({DateTime date, int completedCount, bool fasted})>> historyForRange(
    DateTime start,
    DateTime end,
  ) async {
    final results = <({DateTime date, int completedCount, bool fasted})>[];
    var day = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    while (!day.isAfter(last)) {
      final completed = await completedPrayersOn(day);
      final fasted = await isFastingDay(day);
      results.add((date: day, completedCount: completed.length, fasted: fasted));
      day = day.add(const Duration(days: 1));
    }
    return results;
  }

  static String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
