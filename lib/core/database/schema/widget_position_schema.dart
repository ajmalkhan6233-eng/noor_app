// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Remembers where the user dragged a floating on-screen control
// (Qibla compass, Tasbih counter, Settings gear) so it reappears in
// the same place next launch — keyed by a short widget identifier.

const List<String> widgetPositionCreateStatements = [
  '''
  CREATE TABLE widget_positions (
    widget_key TEXT PRIMARY KEY,
    dx REAL NOT NULL,
    dy REAL NOT NULL,
    updated_at TEXT NOT NULL
  )
  ''',
];
