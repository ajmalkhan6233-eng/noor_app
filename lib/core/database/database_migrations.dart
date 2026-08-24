// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The actual create/upgrade logic DatabaseHelper runs, pulled out to
// top-level functions so a test can exercise the real migration path
// against a plain sqflite_common_ffi database. DatabaseHelper's own
// _open() needs the real encrypted-DB bootstrap (secure passphrase,
// platform channels) that isn't available under `flutter test`, but
// the schema logic itself has no such dependency and shouldn't go
// untested just because of where it's normally called from — see
// test/core/database/migration_test.dart.
//
// Adding a new migration: bump [latestSchemaVersion], add the new
// table/column's CREATE/ALTER statements to the relevant schema file,
// and add a new `if (oldVersion < N)` branch to [upgradeNoorSchema]
// below. Never remove, renumber, or rewrite an existing branch once
// it's shipped, and never assume a fresh install is the only path a
// real user reaches a new version from — see CLAUDE.md's "Update &
// Release Safety" section.

import 'package:sqflite_sqlcipher/sqflite.dart';

import 'schema/azkar_schema.dart';
import 'schema/pilgrimage_schema.dart';
import 'schema/prayer_tracker_schema.dart';
import 'schema/quran_schema.dart';
import 'schema/settings_schema.dart';
import 'schema/tasbih_schema.dart';
import 'schema/widget_position_schema.dart';

const int latestSchemaVersion = 3;

Future<void> createNoorSchema(Database db, int version) async {
  for (final statement in [
    ...tasbihCreateStatements,
    ...settingsCreateStatements,
    ...azkarCreateStatements,
    ...quranCreateStatements,
    ...widgetPositionCreateStatements,
    ...pilgrimageCreateStatements,
    ...prayerTrackerCreateStatements,
  ]) {
    await db.execute(statement);
  }
  for (final statement in azkarSeedStatements) {
    await db.execute(statement);
  }
}

/// Installs that already created a version-1 database are missing the
/// prayer/fasting tracker tables added in version 2 — `IF NOT EXISTS`
/// makes this safe even if a future statement set overlaps. Every
/// user's existing rows in every other table are untouched: this only
/// ever adds tables, it never drops or rewrites one.
Future<void> upgradeNoorSchema(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
  }
  if (oldVersion < 3) {
    await db.execute(
      'ALTER TABLE app_settings ADD COLUMN pre_reminder_enabled INTEGER NOT NULL DEFAULT 0',
    );
    await db.execute(
      'ALTER TABLE app_settings ADD COLUMN pre_reminder_minutes INTEGER NOT NULL DEFAULT 10',
    );
  }
  // Next migration: add `if (oldVersion < 4) { ... }` here.
}
