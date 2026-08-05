// Bismillahir Rahmanir Raheem — watermark: ALLAH

const List<String> prayerTrackerCreateStatements = [
  '''
  CREATE TABLE IF NOT EXISTS prayer_completions (
    date TEXT NOT NULL,
    prayer TEXT NOT NULL,
    PRIMARY KEY (date, prayer)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS fasting_days (
    date TEXT PRIMARY KEY
  )
  ''',
];
