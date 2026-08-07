// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// QuranRepository.ayahOfTheDay against a real (in-memory) SQLite
// database. Confirms: (1) null when nothing is imported, (2) only
// rows with a non-null translation are ever eligible, and (3) the
// pick is deterministic — the same date always yields the same ayah.

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

  test('returns null when nothing has been imported yet', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    final repository = QuranRepository(databaseHelper: DatabaseHelper.forTesting(db));

    final ayah = await repository.ayahOfTheDay(date: DateTime(2026, 8, 7));

    expect(ayah, isNull);
    await db.close();
  });

  test('only ever picks a row that has a translation', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    await db.insert('quran_surahs', {'id': 1, 'ayah_count': 7});
    await db.insert('quran_ayahs', {
      'surah_id': 1,
      'ayah_number': 1,
      'arabic_text': 'placeholder-untranslated',
      'arabic_text_stripped': 'placeholder-untranslated',
    });
    await db.insert('quran_ayahs', {
      'surah_id': 1,
      'ayah_number': 2,
      'arabic_text': 'placeholder-translated',
      'arabic_text_stripped': 'placeholder-translated',
      'translation': 'placeholder translation text',
    });
    final repository = QuranRepository(databaseHelper: DatabaseHelper.forTesting(db));

    final ayah = await repository.ayahOfTheDay(date: DateTime(2026, 8, 7));

    expect(ayah, isNotNull);
    expect(ayah!.ayahNumber, 2);
    expect(ayah.translation, 'placeholder translation text');
    await db.close();
  });

  test('is deterministic for the same date', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    await db.insert('quran_surahs', {'id': 1, 'ayah_count': 7});
    for (var i = 1; i <= 7; i++) {
      await db.insert('quran_ayahs', {
        'surah_id': 1,
        'ayah_number': i,
        'arabic_text': 'placeholder-$i',
        'arabic_text_stripped': 'placeholder-$i',
        'translation': 'placeholder translation $i',
      });
    }
    final repository = QuranRepository(databaseHelper: DatabaseHelper.forTesting(db));

    final first = await repository.ayahOfTheDay(date: DateTime(2026, 8, 7));
    final second = await repository.ayahOfTheDay(date: DateTime(2026, 8, 7));
    final differentDay = await repository.ayahOfTheDay(date: DateTime(2026, 8, 8));

    expect(first!.ayahNumber, second!.ayahNumber);
    expect(differentDay, isNotNull);
    await db.close();
  });
}
