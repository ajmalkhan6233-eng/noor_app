// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Exercises the real create/upgrade path (database_migrations.dart)
// against a version-1 database that already has real user data in
// it, confirming an upgrade to the latest version adds the new
// tables without touching what was already there — the guarantee
// CLAUDE.md's "Update & Release Safety" section requires: an update
// must never silently drop or corrupt someone's existing data.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/database_migrations.dart';
import 'package:noor/core/database/schema/tasbih_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test(
    'upgrading from version 1 adds prayer-tracker tables and keeps existing data',
    () async {
      final dir = await Directory.systemTemp.createTemp('noor_migration_test');
      final path = join(dir.path, 'test.db');
      addTearDown(() => dir.delete(recursive: true));

      // Simulate an existing install: a real version-1 database with
      // a real user's data already saved in an unrelated table.
      final v1 = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            for (final statement in tasbihCreateStatements) {
              await db.execute(statement);
            }
            // Pre-version-3 shape of app_settings, before
            // pre_reminder_enabled/pre_reminder_minutes existed — so
            // this test actually exercises the version-3 ALTER TABLE
            // path, not a table that already has the new columns.
            await db.execute('''
              CREATE TABLE app_settings (
                id INTEGER PRIMARY KEY CHECK (id = 1),
                calculation_method TEXT NOT NULL DEFAULT 'muslimWorldLeague'
              )
            ''');
          },
        ),
      );
      await v1.insert('tasbih_sessions', {
        'dhikr_label': 'Subhanallah',
        'count': 33,
        'target': 33,
        'updated_at': '2026-01-01T00:00:00.000',
      });
      await v1.insert('app_settings', {
        'id': 1,
        'calculation_method': 'muslimWorldLeague',
      });
      await v1.close();

      // Reopen at the latest version via the exact same functions
      // DatabaseHelper calls in production.
      final upgraded = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: latestSchemaVersion,
          onCreate: createNoorSchema,
          onUpgrade: upgradeNoorSchema,
        ),
      );

      // The pre-existing row survived the upgrade untouched.
      final sessions = await upgraded.query('tasbih_sessions');
      expect(sessions, hasLength(1));
      expect(sessions.first['dhikr_label'], 'Subhanallah');
      expect(sessions.first['count'], 33);

      // The version-2 migration's new tables exist and are usable.
      await upgraded.insert('prayer_completions', {
        'date': '2026-01-01',
        'prayer': 'Fajr',
      });
      final completions = await upgraded.query('prayer_completions');
      expect(completions, hasLength(1));

      // The version-3 migration added the pre-reminder columns with
      // their defaults, and the pre-existing settings row survived.
      final settingsRows = await upgraded.query('app_settings');
      expect(settingsRows, hasLength(1));
      expect(settingsRows.first['calculation_method'], 'muslimWorldLeague');
      expect(settingsRows.first['pre_reminder_enabled'], 0);
      expect(settingsRows.first['pre_reminder_minutes'], 10);

      await upgraded.close();
    },
  );

  test('a fresh install at the latest version has every table from the start', () async {
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: latestSchemaVersion,
        onCreate: createNoorSchema,
      ),
    );

    // No exception means every CREATE TABLE in createNoorSchema ran
    // cleanly together (foreign keys, duplicate names, etc. would
    // throw here) — including the seed data insert.
    final azkarCategories = await db.query('azkar_categories');
    expect(azkarCategories, isNotEmpty);

    await db.close();
  });
}
