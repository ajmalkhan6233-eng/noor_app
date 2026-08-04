// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Schema for the Hajj/Umrah pilgrimage tracker. No login, no account —
// a "profile" is only distinguished by its display name, kept purely
// so a shared device can track more than one pilgrim's progress.

const List<String> pilgrimageCreateStatements = [
  '''
  CREATE TABLE pilgrim_profile (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    display_name TEXT NOT NULL,
    total_umrah_completed INTEGER NOT NULL DEFAULT 0,
    total_hajj_completed INTEGER NOT NULL DEFAULT 0,
    experience_level TEXT NOT NULL,
    preferred_language TEXT,
    created_at TEXT NOT NULL
  )
  ''',
  '''
  CREATE TABLE pilgrimage_session (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pilgrim_id INTEGER NOT NULL REFERENCES pilgrim_profile(id),
    type TEXT NOT NULL,
    current_step INTEGER NOT NULL DEFAULT 0,
    tawaf_circuit_count INTEGER NOT NULL DEFAULT 0,
    sai_round_count INTEGER NOT NULL DEFAULT 0,
    is_completed INTEGER NOT NULL DEFAULT 0,
    start_time TEXT NOT NULL,
    end_time TEXT
  )
  ''',
];
