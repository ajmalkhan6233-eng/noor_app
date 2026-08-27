// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against real (in-memory) SQLite databases — proves gather() and
// restore() actually round-trip through real tables, including the
// azkar-bookmark-by-text resolution (not by row id, which isn't
// stable across installs).

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/backup/backup_repository.dart';
import 'package:noor/core/database/database_helper.dart';
import 'package:noor/core/database/schema/azkar_schema.dart';
import 'package:noor/core/database/schema/prayer_tracker_schema.dart';
import 'package:noor/core/database/schema/quran_schema.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// A unique path per call rather than the shared `inMemoryDatabasePath`
// constant — sqflite_common_ffi otherwise reconnects to the same
// underlying database across separate openDatabase() calls even after
// an earlier one was closed, which silently merges data between what
// are meant to be two independent devices in these tests. Seeded with
// the current time (not just an in-run counter) so a leftover file
// from a previous test run on disk can never collide either.
int _dbCounter = 0;

Future<Database> _openFullSchema() async {
  final uniqueName = 'backup_test_${DateTime.now().microsecondsSinceEpoch}_${_dbCounter++}.db';
  final db = await databaseFactoryFfi.openDatabase(uniqueName);
  for (final statement in [
    ...prayerTrackerCreateStatements,
    ...quranCreateStatements,
    ...azkarCreateStatements,
  ]) {
    await db.execute(statement);
  }
  for (final statement in azkarSeedStatements) {
    await db.execute(statement);
  }
  return db;
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('gather then restore into a fresh device reproduces the same data', () async {
    final sourceDb = await _openFullSchema();
    await sourceDb.insert('prayer_completions', {'date': '2026-08-20', 'prayer': 'Fajr'});
    await sourceDb.insert('fasting_days', {'date': '2026-08-19'});
    await sourceDb.insert('quran_bookmarks', {
      'surah_id': 2,
      'ayah_number': 255,
      'created_at': '2026-08-18T09:00:00Z',
    });
    final itemId = await sourceDb.insert('azkar_items', {
      'category_id': 1,
      'arabic_text': 'سُبْحَانَ اللَّهِ',
      'repeat_count': 33,
      'source': 'test',
      'display_order': 1,
    });
    await sourceDb.insert('azkar_bookmarks', {
      'item_id': itemId,
      'created_at': '2026-08-17T09:00:00Z',
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('zakat_last_gold_price_per_gram', 25.5);

    final sourceRepo = BackupRepository(databaseHelper: DatabaseHelper.forTesting(sourceDb));
    final payload = await sourceRepo.gather();
    await sourceDb.close();

    // A different device: same dataset re-imported, so the same
    // azkar item text exists again but very possibly under a
    // different autoincrement id — this is the exact scenario the
    // by-text matching exists for.
    final targetDb = await _openFullSchema();
    // A filler row first, purely so the real item's autoincrement id
    // is forced to differ from the source device's — otherwise two
    // independently-fresh databases would both trivially assign id 1
    // to their first row, which wouldn't actually prove text-based
    // matching is doing anything.
    await targetDb.insert('azkar_items', {
      'category_id': 1,
      'arabic_text': 'filler',
      'repeat_count': 1,
      'source': 'test',
      'display_order': 0,
    });
    final targetItemId = await targetDb.insert('azkar_items', {
      'category_id': 1,
      'arabic_text': 'سُبْحَانَ اللَّهِ',
      'repeat_count': 33,
      'source': 'test',
      'display_order': 1,
    });
    expect(targetItemId, isNot(itemId), reason: 'must differ to prove text-matching, not id-matching');

    final targetRepo = BackupRepository(databaseHelper: DatabaseHelper.forTesting(targetDb));
    final result = await targetRepo.restore(payload);

    expect(result.azkarBookmarksSkipped, 0);
    expect(
      await targetDb.query('prayer_completions'),
      [{'date': '2026-08-20', 'prayer': 'Fajr'}],
    );
    expect(await targetDb.query('fasting_days'), [{'date': '2026-08-19'}]);
    final restoredBookmarks = await targetDb.query('azkar_bookmarks');
    expect(restoredBookmarks.single['item_id'], targetItemId);

    final targetPrefs = await SharedPreferences.getInstance();
    expect(targetPrefs.getDouble('zakat_last_gold_price_per_gram'), 25.5);

    await targetDb.close();
  });

  test('restoring twice never duplicates rows', () async {
    final db = await _openFullSchema();
    await db.insert('prayer_completions', {'date': '2026-08-20', 'prayer': 'Fajr'});
    final repo = BackupRepository(databaseHelper: DatabaseHelper.forTesting(db));
    final payload = await repo.gather();

    await repo.restore(payload);
    await repo.restore(payload);

    expect((await db.query('prayer_completions')).length, 1);
    await db.close();
  });
}
