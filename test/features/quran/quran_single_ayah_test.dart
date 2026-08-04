// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// QuranRepository.singleAyah against a real (in-memory) SQLite
// database — not a mock — so both the empty-table and the populated
// paths run the actual query.

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

  test('returns null when the Quran has not been imported yet', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    final repository = QuranRepository(databaseHelper: DatabaseHelper.forTesting(db));

    final ayah = await repository.singleAyah(2, 201);

    expect(ayah, isNull);
    await db.close();
  });

  test('returns the ayah once it has been imported', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    await db.insert('quran_surahs', {
      'id': 2,
      'ayah_count': 286,
      'name_translit': 'Al-Baqara',
    });
    await db.insert('quran_ayahs', {
      'surah_id': 2,
      'ayah_number': 201,
      'arabic_text': 'placeholder-for-test-only',
      'arabic_text_stripped': 'placeholder-for-test-only',
    });
    final repository = QuranRepository(databaseHelper: DatabaseHelper.forTesting(db));

    final ayah = await repository.singleAyah(2, 201);

    expect(ayah, isNotNull);
    expect(ayah!.surahId, 2);
    expect(ayah.ayahNumber, 201);
    await db.close();
  });
}
