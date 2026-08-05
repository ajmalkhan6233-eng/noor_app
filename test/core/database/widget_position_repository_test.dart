// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against a real (in-memory) SQLite database, so the scale column and
// the plain drag-only path are both exercised for real. Each test
// closes its own connection — sqflite_common_ffi otherwise reuses the
// same in-memory database across `openDatabase(inMemoryDatabasePath)`
// calls and later CREATE TABLEs collide.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/database_helper.dart';
import 'package:noor/core/database/schema/widget_position_schema.dart';
import 'package:noor/core/database/widget_position_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('plain save/load round-trips position and defaults scale to 1.0', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in widgetPositionCreateStatements) {
      await db.execute(statement);
    }
    final repository = WidgetPositionRepository(databaseHelper: DatabaseHelper.forTesting(db));

    await repository.save('tasbih_counter', const Offset(12, 34));

    expect(await repository.load('tasbih_counter'), const Offset(12, 34));
    final withScale = await repository.loadWithScale('tasbih_counter');
    expect(withScale!.scale, 1.0);
    await db.close();
  });

  test('saveWithScale/loadWithScale round-trips both position and scale', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in widgetPositionCreateStatements) {
      await db.execute(statement);
    }
    final repository = WidgetPositionRepository(databaseHelper: DatabaseHelper.forTesting(db));

    await repository.saveWithScale('qibla_compass', const Offset(5, 6), 1.35);

    final saved = await repository.loadWithScale('qibla_compass');
    expect(saved!.offset, const Offset(5, 6));
    expect(saved.scale, 1.35);
    expect(await repository.load('qibla_compass'), const Offset(5, 6));
    await db.close();
  });

  test('a later plain save() does not reset a previously saved scale', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in widgetPositionCreateStatements) {
      await db.execute(statement);
    }
    final repository = WidgetPositionRepository(databaseHelper: DatabaseHelper.forTesting(db));

    await repository.saveWithScale('qibla_compass', const Offset(0, 0), 1.4);
    await repository.save('qibla_compass', const Offset(9, 9));

    final saved = await repository.loadWithScale('qibla_compass');
    expect(saved!.offset, const Offset(9, 9));
    expect(saved.scale, 1.4);
    await db.close();
  });

  test('clear removes both position and scale', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    for (final statement in widgetPositionCreateStatements) {
      await db.execute(statement);
    }
    final repository = WidgetPositionRepository(databaseHelper: DatabaseHelper.forTesting(db));

    await repository.saveWithScale('qibla_compass', const Offset(1, 1), 1.2);
    await repository.clear('qibla_compass');

    expect(await repository.load('qibla_compass'), isNull);
    expect(await repository.loadWithScale('qibla_compass'), isNull);
    await db.close();
  });
}
