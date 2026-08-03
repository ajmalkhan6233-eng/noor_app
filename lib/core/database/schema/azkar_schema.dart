// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Azkar schema. `azkar_items` is intentionally left empty by
// `azkarSeedStatements` — TODO: import a properly sourced azkar
// collection; every row that goes in later MUST carry a non-empty
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
];

/// Category keys only — structural metadata, not dhikr text. Order
/// matches the five categories the feature is scoped for.
const List<String> azkarSeedStatements = [
  "INSERT INTO azkar_categories (category_key, display_order) VALUES "
      "('morning', 0), ('evening', 1), ('after_prayer', 2), "
      "('sleep', 3), ('travel', 4)",
];
