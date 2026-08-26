// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against a real (in-memory) SQLite database and the real bundled
// asset — proves the visiting_sick split actually moves the two
// duplicate rows out of illness rather than leaving both, and that
// the new virtue-of-visiting item lands correctly.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/schema/azkar_schema.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import_2.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import_3.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<int> countFor(dynamic db, String categoryKey) async {
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

  test(
    'moves the two shared items out of illness into visiting_sick, '
    'leaving illness with only the despaired-of-life dua',
    () async {
      final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      for (final statement in azkarCreateStatements) {
        await db.execute(statement);
      }
      for (final statement in azkarSeedStatements) {
        await db.execute(statement);
      }

      await ensureAzkarSupplementary2Imported(db);
      expect(await countFor(db, 'illness'), 5);

      await ensureAzkarSupplementary3Imported(db);

      expect(await countFor(db, 'illness'), 3);
      expect(await countFor(db, 'visiting_sick'), 3);

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

    await ensureAzkarSupplementary2Imported(db);
    await ensureAzkarSupplementary3Imported(db);
    final firstCount = (await db.query('azkar_items')).length;
    await ensureAzkarSupplementary3Imported(db);
    final secondCount = (await db.query('azkar_items')).length;

    expect(secondCount, firstCount);

    await db.close();
  });
}
