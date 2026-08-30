// Bismillahir Rahmanir Raheem — watermark: ALLAH

import '../../../core/database/database_helper.dart';
import 'calendar_reminder.dart';

String _isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

class CalendarReminderRepository {
  CalendarReminderRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<List<CalendarReminder>> remindersOn(DateTime date) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'calendar_reminders',
      where: 'date = ?',
      whereArgs: [_isoDate(date)],
      orderBy: 'hour ASC, minute ASC',
    );
    return [for (final row in rows) _fromRow(row)];
  }

  /// Every date (day precision) that has at least one reminder, within
  /// [monthStart]..[monthEnd] inclusive — used to draw a dot on the
  /// month grid without loading every reminder's full detail.
  Future<Set<DateTime>> datesWithReminders(DateTime monthStart, DateTime monthEnd) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'calendar_reminders',
      columns: ['DISTINCT date'],
      where: 'date >= ? AND date <= ?',
      whereArgs: [_isoDate(monthStart), _isoDate(monthEnd)],
    );
    return {
      for (final row in rows) DateTime.parse(row['date']! as String),
    };
  }

  /// Returns the new reminder's id — the caller needs it to schedule
  /// (and later cancel) the matching local notification.
  Future<int> add({required DateTime date, required String note, required int hour, required int minute}) async {
    final db = await _dbHelper.database;
    return db.insert('calendar_reminders', {
      'date': _isoDate(date),
      'note': note,
      'hour': hour,
      'minute': minute,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('calendar_reminders', where: 'id = ?', whereArgs: [id]);
  }

  CalendarReminder _fromRow(Map<String, Object?> row) {
    final date = DateTime.parse(row['date']! as String);
    return CalendarReminder(
      id: row['id']! as int,
      date: date,
      note: row['note']! as String,
      hour: row['hour']! as int,
      minute: row['minute']! as int,
    );
  }
}
