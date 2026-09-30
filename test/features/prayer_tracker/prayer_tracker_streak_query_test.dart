// Bismillahir Rahmanir Raheem — watermark: ALLAH

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

  test('streaks and history come from grouped reads and stay correct across a month edge', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repo = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final today = DateTime(2026, 3, 2);

    // 4 perfect days ending today (Mar 2, 1, Feb 28, 27), then a gap.
    for (var i = 0; i < 4; i++) {
      final day = DateTime(2026, 3, 2 - i);
      for (final prayer in trackedPrayers) {
        await repo.setPrayerCompleted(day, prayer, completed: true);
      }
      await repo.setFastingDay(day, fasted: true);
    }
    // Partial day before the gap must not extend the streak.
    await repo.setPrayerCompleted(DateTime(2026, 2, 25), 'Fajr', completed: true);

    expect(await repo.currentPrayerStreak(today), 4);
    expect(await repo.currentFastingStreak(today), 4);
    expect(await repo.currentPrayerStreak(DateTime(2026, 2, 26)), 0);

    final history = await repo.historyForRange(DateTime(2026, 2, 25), today);
    expect(history.map((d) => d.completedCount).toList(), [1, 0, 5, 5, 5, 5]);
    expect(history.map((d) => d.fasted).toList(), [false, false, true, true, true, true]);
    await db.close();
  });
}
