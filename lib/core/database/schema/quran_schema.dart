// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Quran schema. Every table here starts empty — populated only by
// `QuranImportService` from a SHA-256-verified Tanzil asset the user
// supplies. No Quranic text is ever authored in this codebase.

const List<String> quranCreateStatements = [
  '''
  CREATE TABLE quran_surahs (
    id INTEGER PRIMARY KEY,
    name_arabic TEXT,
    name_translit TEXT,
    name_english TEXT,
    revelation_place TEXT,
    ayah_count INTEGER NOT NULL
  )
  ''',
  '''
  CREATE TABLE quran_ayahs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    surah_id INTEGER NOT NULL REFERENCES quran_surahs(id),
    ayah_number INTEGER NOT NULL,
    arabic_text TEXT NOT NULL,
    arabic_text_stripped TEXT NOT NULL,
    translation TEXT,
    UNIQUE(surah_id, ayah_number)
  )
  ''',
  '''
  CREATE TABLE quran_bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    surah_id INTEGER NOT NULL,
    ayah_number INTEGER NOT NULL,
    created_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE quran_last_read (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    surah_id INTEGER NOT NULL,
    ayah_number INTEGER NOT NULL,
    updated_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE quran_import_meta (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    imported_sha256 TEXT NOT NULL,
    imported_metadata_sha256 TEXT NOT NULL,
    imported_at TEXT NOT NULL
  )
  ''',
];
