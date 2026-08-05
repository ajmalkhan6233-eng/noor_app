// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against a real (in-memory) SQLite database and the real bundled
// asset (loaded via rootBundle, same as production) — proves the
// backfill actually reaches the `translation` column, not just that
// the parser produces rows.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/schema/quran_schema.dart';
import 'package:noor/features/quran/data/quran_translation_backfill.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('backfills translation text into a pre-existing ayah row', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    await db.insert('quran_surahs', {
      'id': 1,
      'name_arabic': 'الفاتحة',
      'name_translit': 'Al-Faatiha',
      'name_english': 'The Opening',
      'revelation_place': 'meccan',
      'ayah_count': 7,
    });
    await db.insert('quran_ayahs', {
      'surah_id': 1,
      'ayah_number': 1,
      'arabic_text': 'placeholder',
      'arabic_text_stripped': 'placeholder',
    });

    await ensureQuranTranslationImported(db);

    final rows = await db.query(
      'quran_ayahs',
      where: 'surah_id = 1 AND ayah_number = 1',
    );
    expect(
      rows.single['translation'],
      'In the name of Allah, the Entirely Merciful, the Especially Merciful',
    );

    final meta = await db.query('quran_translation_import_meta', where: 'id = 1');
    expect(meta, hasLength(1));

    await db.close();
  });

  test('is a no-op on a second call once already imported', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    await db.insert('quran_surahs', {
      'id': 1,
      'name_arabic': 'الفاتحة',
      'name_translit': 'Al-Faatiha',
      'name_english': 'The Opening',
      'revelation_place': 'meccan',
      'ayah_count': 7,
    });
    await db.insert('quran_ayahs', {
      'surah_id': 1,
      'ayah_number': 1,
      'arabic_text': 'placeholder',
      'arabic_text_stripped': 'placeholder',
    });

    await ensureQuranTranslationImported(db);
    await db.update('quran_ayahs', {'translation': 'edited by hand'});
    await ensureQuranTranslationImported(db);

    final rows = await db.query('quran_ayahs');
    expect(rows.single['translation'], 'edited by hand');

    await db.close();
  });
}
