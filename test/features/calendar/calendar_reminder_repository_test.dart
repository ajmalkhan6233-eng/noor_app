// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/database_helper.dart';
import 'package:noor/core/database/schema/calendar_reminder_schema.dart';
import 'package:noor/features/calendar/data/calendar_reminder_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late CalendarReminderRepository repository;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in calendarReminderCreateStatements) {
      await db.execute(statement);
    }
    repository = CalendarReminderRepository(databaseHelper: DatabaseHelper.forTesting(db));
  });

  tearDown(() => db.close());

  test('a reminder added on one date is returned by remindersOn that exact date', () async {
    final date = DateTime(2026, 9, 3);

    final id = await repository.add(date: date, note: 'Pay Zakat', hour: 9, minute: 30);

    final reminders = await repository.remindersOn(date);
    expect(reminders, hasLength(1));
    expect(reminders.first.id, id);
    expect(reminders.first.note, 'Pay Zakat');
    expect(reminders.first.hour, 9);
    expect(reminders.first.minute, 30);
  });

  test('reminders on a different date are not returned', () async {
    await repository.add(date: DateTime(2026, 9, 3), note: 'A', hour: 9, minute: 0);

    expect(await repository.remindersOn(DateTime(2026, 9, 4)), isEmpty);
  });

  test('reminders on the same date are ordered by time', () async {
    final date = DateTime(2026, 9, 3);
    await repository.add(date: date, note: 'Later', hour: 18, minute: 0);
    await repository.add(date: date, note: 'Earlier', hour: 8, minute: 0);

    final reminders = await repository.remindersOn(date);
    expect(reminders.map((r) => r.note).toList(), ['Earlier', 'Later']);
  });

  test('delete removes the reminder', () async {
    final date = DateTime(2026, 9, 3);
    final id = await repository.add(date: date, note: 'A', hour: 9, minute: 0);

    await repository.delete(id);

    expect(await repository.remindersOn(date), isEmpty);
  });

  test('datesWithReminders returns only dates within range that have a reminder', () async {
    await repository.add(date: DateTime(2026, 9, 3), note: 'A', hour: 9, minute: 0);
    await repository.add(date: DateTime(2026, 9, 20), note: 'B', hour: 9, minute: 0);
    await repository.add(date: DateTime(2026, 10, 1), note: 'C', hour: 9, minute: 0);

    final dates = await repository.datesWithReminders(DateTime(2026, 9, 1), DateTime(2026, 9, 30));

    expect(dates, {DateTime(2026, 9, 3), DateTime(2026, 9, 20)});
  });
}
