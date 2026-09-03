// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against a real (in-memory) SQLite database and the real bundled
// asset — proves the backfill actually reaches azkar_items with the
// right category, not just that the asset parses.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/schema/azkar_schema.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import_5.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test(
    'populates waking_up, home, clothing, toilet, wudu, mosque, anger, '
    'fear, sneezing with attributed items',
    () async {
      final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      for (final statement in azkarCreateStatements) {
        await db.execute(statement);
      }
      for (final statement in azkarSeedStatements) {
        await db.execute(statement);
      }

      await ensureAzkarSupplementary5Imported(db);

      Future<int> countFor(String categoryKey) async {
        final category = await db.query(
          'azkar_categories',
          where: 'category_key = ?',
          whereArgs: [categoryKey],
        );
        final categoryId = category.single['id'];
        final items = await db.query(
          'azkar_items',
          where: 'category_id = ?',
          whereArgs: [categoryId],
        );
        for (final item in items) {
          expect(item['source'], isNotEmpty);
        }
        return items.length;
      }

      expect(await countFor('waking_up'), 4);
      expect(await countFor('home'), 3);
      expect(await countFor('clothing'), 5);
      expect(await countFor('toilet'), 2);
      expect(await countFor('wudu'), 4);
      expect(await countFor('mosque'), 12);
      expect(await countFor('anger'), 1);
      expect(await countFor('fear'), 3);
      expect(await countFor('sneezing'), 2);

      await db.close();
    },
  );

  test('is a no-op on a second call once already imported', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in azkarCreateStatements) {
      await db.execute(statement);
    }
    for (final statement in azkarSeedStatements) {
      await db.execute(statement);
    }

    await ensureAzkarSupplementary5Imported(db);
    final firstCount = (await db.query('azkar_items')).length;
    await ensureAzkarSupplementary5Imported(db);
    final secondCount = (await db.query('azkar_items')).length;

    expect(secondCount, firstCount);

    await db.close();
  });
}
