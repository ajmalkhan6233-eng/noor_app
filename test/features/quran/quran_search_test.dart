// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-09-12 fix: search() only queried
// arabic_text_stripped, so any English query returned zero results by
// design. Against a real (in-memory) SQLite database — not a mock —
// confirms a translation-text word and a surah name both now return
// real results.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/database_helper.dart';
import 'package:noor/core/database/schema/quran_schema.dart';
import 'package:noor/features/quran/data/quran_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late QuranRepository repository;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    await db.insert('quran_surahs', {
      'id': 18,
      'ayah_count': 110,
      'name_translit': 'Al-Kahf',
      'name_english': 'The Cave',
    });
    await db.insert('quran_surahs', {
      'id': 1,
      'ayah_count': 7,
      'name_translit': 'Al-Fatihah',
      'name_english': 'The Opening',
    });
    await db.insert('quran_ayahs', {
      'surah_id': 18,
      'ayah_number': 1,
      'arabic_text': 'arabic-placeholder-18-1',
      'arabic_text_stripped': 'arabic-placeholder-18-1',
      'translation': 'All praise is due to Allah, who has sent down upon His Servant the Book.',
    });
    await db.insert('quran_ayahs', {
      'surah_id': 1,
      'ayah_number': 2,
      'arabic_text': 'arabic-placeholder-1-2',
      'arabic_text_stripped': 'arabic-placeholder-1-2',
      'translation': '[All] praise is [due] to Allah, Lord of the worlds.',
    });
    repository = QuranRepository(databaseHelper: DatabaseHelper.forTesting(db));
  });

  tearDown(() => db.close());

  test('a translation-text word returns matching ayahs', () async {
    final results = await repository.search('praise');

    expect(results.length, 2);
    expect(results.map((a) => (a.surahId, a.ayahNumber)), containsAll([(18, 1), (1, 2)]));
  });

  test('a surah name returns every ayah in that surah, not just text matches', () async {
    final results = await repository.search('Kahf');

    expect(results.length, 1);
    expect(results.single.surahId, 18);
  });

  test("a surah's English name also matches", () async {
    final results = await repository.search('Cave');

    expect(results.length, 1);
    expect(results.single.surahId, 18);
  });

  test('an unmatched query returns no results', () async {
    final results = await repository.search('nonexistentqueryword');

    expect(results, isEmpty);
  });
}
