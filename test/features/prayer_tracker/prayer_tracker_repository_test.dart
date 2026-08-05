// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against a real (in-memory) SQLite database. Each test opens and
// closes its own connection — sqflite_common_ffi otherwise reuses the
// same in-memory database across `openDatabase(inMemoryDatabasePath)`
// calls and rows from an earlier test leak into the next one.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/database_helper.dart';
import 'package:noor/core/database/schema/prayer_tracker_schema.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('completedPrayersOn is empty until a prayer is marked done', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repository = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final today = DateTime(2026, 3, 10);

    expect(await repository.completedPrayersOn(today), isEmpty);

    await repository.setPrayerCompleted(today, 'Fajr', completed: true);

    expect(await repository.completedPrayersOn(today), {'Fajr'});
    await db.close();
  });

  test('unmarking a prayer removes it again', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repository = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final today = DateTime(2026, 3, 10);

    await repository.setPrayerCompleted(today, 'Dhuhr', completed: true);
    await repository.setPrayerCompleted(today, 'Dhuhr', completed: false);

    expect(await repository.completedPrayersOn(today), isEmpty);
    await db.close();
  });

  test('fasting day round-trips and defaults to false', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repository = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final today = DateTime(2026, 3, 10);

    expect(await repository.isFastingDay(today), isFalse);

    await repository.setFastingDay(today, fasted: true);
    expect(await repository.isFastingDay(today), isTrue);

    await repository.setFastingDay(today, fasted: false);
    expect(await repository.isFastingDay(today), isFalse);
    await db.close();
  });

  test('prayer streak counts consecutive fully-completed days and stops at a gap', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repository = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final day3 = DateTime(2026, 3, 3);
    final day2 = DateTime(2026, 3, 2);
    final day1 = DateTime(2026, 3, 1);

    for (final prayer in trackedPrayers) {
      await repository.setPrayerCompleted(day3, prayer, completed: true);
      await repository.setPrayerCompleted(day2, prayer, completed: true);
    }
    // day1 left incomplete (only 4 of 5 prayers).
    for (final prayer in trackedPrayers.take(4)) {
      await repository.setPrayerCompleted(day1, prayer, completed: true);
    }

    expect(await repository.currentPrayerStreak(day3), 2);
    await db.close();
  });

  test('prayer streak is zero when today is not fully completed', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repository = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final today = DateTime(2026, 3, 10);

    await repository.setPrayerCompleted(today, 'Fajr', completed: true);

    expect(await repository.currentPrayerStreak(today), 0);
    await db.close();
  });

  test('fasting streak counts consecutive fasted days and stops at a gap', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repository = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final day3 = DateTime(2026, 3, 3);
    final day2 = DateTime(2026, 3, 2);

    await repository.setFastingDay(day3, fasted: true);
    await repository.setFastingDay(day2, fasted: true);
    // day1 deliberately left unfasted.

    expect(await repository.currentFastingStreak(day3), 2);
    await db.close();
  });
}
