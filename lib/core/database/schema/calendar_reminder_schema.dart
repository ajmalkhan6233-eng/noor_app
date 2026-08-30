// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Calendar tab reminders — a note + a time, attached to a specific
// Gregorian date (master directive items 10/11, 2026-08-30). `date` is
// stored as an ISO `yyyy-MM-dd` string (day precision only — time
// lives in its own columns) so "reminders on this date" is a plain
// equality match, not a range query.

const List<String> calendarReminderCreateStatements = [
  '''
  CREATE TABLE calendar_reminders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL,
    note TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    created_at TEXT NOT NULL
  )
  ''',
];
