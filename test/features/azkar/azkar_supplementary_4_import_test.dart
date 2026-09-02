// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against a real (in-memory) SQLite database and the real bundled
// asset — proves the backfill actually reaches azkar_items with the
// right category, not just that the asset parses.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/schema/azkar_schema.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import_4.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test(
    'populates funeral, weather, food_fasting, marriage with attributed items',
    () async {
      final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      for (final statement in azkarCreateStatements) {
        await db.execute(statement);
      }
      for (final statement in azkarSeedStatements) {
        await db.execute(statement);
      }

      await ensureAzkarSupplementary4Imported(db);

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

      expect(await countFor('funeral'), 14);
      expect(await countFor('weather'), 9);
      expect(await countFor('food_fasting'), 12);
      expect(await countFor('marriage'), 3);

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

    await ensureAzkarSupplementary4Imported(db);
    final firstCount = (await db.query('azkar_items')).length;
    await ensureAzkarSupplementary4Imported(db);
    final secondCount = (await db.query('azkar_items')).length;

    expect(secondCount, firstCount);

    await db.close();
  });
}
