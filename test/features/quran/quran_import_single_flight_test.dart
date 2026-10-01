// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The background pre-warm and the Quran screen must share one import.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/database_helper.dart';
import 'package:noor/core/database/schema/quran_schema.dart';
import 'package:noor/features/quran/data/quran_import_service.dart';
import 'package:noor/features/quran/data/quran_prewarm.dart';
import 'package:noor/features/quran/data/quran_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('pre-warm and a concurrent open share one import, with no duplicate rows', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in quranCreateStatements) {
      await db.execute(statement);
    }
    final helper = DatabaseHelper.forTesting(db);
    final service = QuranImportService(databaseHelper: helper);

    final warm = prewarmQuran(importService: service, repository: QuranRepository(databaseHelper: helper));
    final screen = service.ensureImported();
    await Future.wait([warm, screen]);

    final count = (await db.rawQuery('SELECT COUNT(*) AS n FROM quran_ayahs')).single['n'];
    expect(count, 6236);
    expect((await db.query('quran_import_meta')).length, 1);
    await db.close();
  });

  test('pre-warm never throws, even if the import cannot run', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath); // no schema
    final helper = DatabaseHelper.forTesting(db);
    await prewarmQuran(
      importService: QuranImportService(databaseHelper: helper),
      repository: QuranRepository(databaseHelper: helper),
    );
    await db.close();
  });
}
