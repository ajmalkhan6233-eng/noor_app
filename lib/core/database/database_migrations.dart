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
import 'schema/prayer_tracker_schema.dart';
import 'schema/quran_schema.dart';
import 'schema/settings_schema.dart';
import 'schema/tasbih_schema.dart';
import 'schema/widget_position_schema.dart';

const int latestSchemaVersion = 7;

Future<void> createNoorSchema(Database db, int version) async {
  for (final statement in [
    ...tasbihCreateStatements,
    ...settingsCreateStatements,
    ...azkarCreateStatements,
    ...quranCreateStatements,
    ...widgetPositionCreateStatements,
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
  if (oldVersion < 4) {
    await db.execute(
      'ALTER TABLE app_settings ADD COLUMN has_seen_location_onboarding INTEGER NOT NULL DEFAULT 0',
    );
  }
  if (oldVersion < 5) {
    await db.execute('ALTER TABLE app_settings ADD COLUMN profile_name TEXT');
  }
  if (oldVersion < 6) {
    // Five new azkar categories (see azkar_schema.dart's seed list
    // comment for provenance). CREATE TABLE IF NOT EXISTS first rather
    // than assuming azkar_categories already exists — migration_test's
    // simulated old database (deliberately minimal, to isolate exactly
    // what each version branch adds) doesn't have it, and there's no
    // real guarantee every historical install does either; INSERT OR
    // IGNORE similarly guards against re-adding a category that's
    // somehow already there. Deliberately not reusing
    // azkarCreateStatements here — those CREATE TABLE statements have
    // no IF NOT EXISTS and would throw on a real install that already
    // has this table (the overwhelmingly common case).
    await db.execute('''
      CREATE TABLE IF NOT EXISTS azkar_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_key TEXT NOT NULL UNIQUE,
        display_order INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS azkar_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL REFERENCES azkar_categories(id),
        arabic_text TEXT NOT NULL,
        transliteration TEXT,
        translation TEXT,
        repeat_count INTEGER NOT NULL DEFAULT 1,
        source TEXT NOT NULL,
        display_order INTEGER NOT NULL
      )
    ''');
    // Both the original five and the new five, all as INSERT OR
    // IGNORE — if the table already existed with the original five
    // (the normal case), those are silently skipped and only the new
    // five land; if it didn't exist at all until the CREATE TABLE IF
    // NOT EXISTS just above, every install still ends up with all ten.
    await db.execute(
      "INSERT OR IGNORE INTO azkar_categories (category_key, display_order) VALUES "
      "('morning', 0), ('evening', 1), ('after_prayer', 2), "
      "('sleep', 3), ('travel', 4), ('child_protection', 5), "
      "('illness', 6), ('distress', 7), ('debt', 8), "
      "('visiting_grave', 9)",
    );
  }
  if (oldVersion < 7) {
    // Duas & Dhikr bookmarks, direct request (2026-08-26) - one row
    // per bookmarked azkar item, same shape as azkar_progress.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS azkar_bookmarks (
        item_id INTEGER PRIMARY KEY REFERENCES azkar_items(id),
        created_at TEXT NOT NULL
      )
    ''');
  }
  // Next migration: add `if (oldVersion < 8) { ... }` here.
}
