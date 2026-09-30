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

  test('marking a prayer or fast twice does not throw and stores one row', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    final repository = PrayerTrackerRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final day = DateTime(2026, 3, 10);

    await repository.setPrayerCompleted(day, 'Fajr', completed: true);
    await repository.setPrayerCompleted(day, 'Fajr', completed: true);
    await repository.setFastingDay(day, fasted: true);
    await repository.setFastingDay(day, fasted: true);

    expect(await repository.completedPrayersOn(day), {'Fajr'});
    expect(await repository.isFastingDay(day), isTrue);
    await db.close();
  });
}
