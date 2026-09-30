// Bismillahir Rahmanir Raheem — watermark: ALLAH

// Migrations for databases created before schema version 7, moved out
// of database_migrations.dart to keep that file short. Called first by
// upgradeNoorSchema; the branches are unchanged.

import 'package:sqflite_sqlcipher/sqflite.dart';

import 'schema/prayer_tracker_schema.dart';

Future<void> upgradeNoorSchemaBeforeV7(Database db, int oldVersion) async {
  if (oldVersion < 2) {
    for (final statement in prayerTrackerCreateStatements) {
      await db.execute(statement);
    }
    // Ensure no stray seed rows are left
    await db.delete('prayer_completions');
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
}
