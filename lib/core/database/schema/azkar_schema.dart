// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Azkar schema. `azkar_items` starts empty and is populated by
// `AzkarImportService` from a SHA-256-verified, MIT-licensed dataset —
// see `assets/azkar/README.md`. Every row carries a non-empty
// `source` citation, hence that column being NOT NULL.

const List<String> azkarCreateStatements = [
  '''
  CREATE TABLE azkar_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_key TEXT NOT NULL UNIQUE,
    display_order INTEGER NOT NULL
  )
  ''',
  '''
  CREATE TABLE azkar_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL REFERENCES azkar_categories(id),
    arabic_text TEXT NOT NULL,
    transliteration TEXT,
    translation TEXT,
    repeat_count INTEGER NOT NULL DEFAULT 1,
    source TEXT NOT NULL,
    display_order INTEGER NOT NULL
  )
  ''',
  '''
  CREATE TABLE azkar_progress (
    item_id INTEGER PRIMARY KEY REFERENCES azkar_items(id),
    count INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE azkar_import_meta (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    imported_ar_sha256 TEXT NOT NULL,
    imported_en_sha256 TEXT NOT NULL,
    imported_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE azkar_bookmarks (
    item_id INTEGER PRIMARY KEY REFERENCES azkar_items(id),
    created_at TEXT NOT NULL
  )
  ''',
];

/// Category keys only — structural metadata, not dhikr text. The
/// last five (child_protection/illness/distress/debt/visiting_grave)
/// were added 2026-08-25 — see assets/azkar/README.md's "Source
/// (child_protection / illness / distress / debt / visiting_grave)"
/// section for their hisn.json provenance. Upgrading installs get
/// these via database_migrations.dart's `oldVersion < 6` branch —
/// this statement only runs for a fresh install.
const List<String> azkarSeedStatements = [
  // Every category ever added, original ten plus every migration
  // since — a fresh install runs createNoorSchema() directly at
  // latestSchemaVersion and never walks the oldVersion<N migration
  // branches below, so a category added only to a migration branch
  // (as the nine 2026-09-01 categories originally were) never gets
  // seeded on a fresh install; its azkar_items rows then have nowhere
  // to attach (categoryIds[category] comes back null and the import
  // silently skips every row) — found live: "During Prayer" showed
  // the empty state on a fresh uninstall+reinstall despite the JSON
  // having 52 entries for it.
  "INSERT INTO azkar_categories (category_key, display_order) VALUES "
      "('morning', 0), ('evening', 1), ('after_prayer', 2), "
      "('sleep', 3), ('travel', 4), ('child_protection', 5), "
      "('illness', 6), ('distress', 7), ('debt', 8), "
      "('visiting_grave', 9), ('visiting_sick', 10), "
      "('purification', 11), ('during_prayer', 12), ('death_and_funeral', 13), "
      "('weather', 14), ('eating_and_fasting', 15), ('daily_life', 16), "
      "('hajj_umrah', 17), ('remembrance', 18), ('everyday_moments', 19)",
];
