// Bismillahir Rahmanir Raheem — watermark: ALLAH

const List<String> tasbihCreateStatements = [
  '''
  CREATE TABLE tasbih_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dhikr_label TEXT NOT NULL,
    count INTEGER NOT NULL DEFAULT 0,
    target INTEGER,
    updated_at TEXT NOT NULL
  )
  ''',
];
