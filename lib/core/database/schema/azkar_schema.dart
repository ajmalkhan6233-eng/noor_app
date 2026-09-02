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

/// Category keys only — structural metadata, not dhikr text.
/// child_protection/illness/distress/debt/visiting_grave were added
/// 2026-08-25, visiting_sick 2026-08-26, and funeral/weather/
/// food_fasting/marriage most recently — see assets/azkar/README.md's
/// "Source" sections for each batch's hisn.json provenance. Upgrading
/// installs get these via database_migrations.dart's `oldVersion < 6`,
/// `< 8`, and `< 11` branches — this statement only runs for a fresh
/// install.
const List<String> azkarSeedStatements = [
  "INSERT INTO azkar_categories (category_key, display_order) VALUES "
      "('morning', 0), ('evening', 1), ('after_prayer', 2), "
      "('sleep', 3), ('travel', 4), ('child_protection', 5), "
      "('illness', 6), ('distress', 7), ('debt', 8), "
      "('visiting_grave', 9), ('visiting_sick', 10), "
      "('funeral', 11), ('weather', 12), ('food_fasting', 13), "
      "('marriage', 14)",
];
