// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure maths for the month heatmap: which cells a month has (Monday
// first) and how strongly each day is shaded.

class MonthCell {
  const MonthCell({required this.date, required this.count});

  final DateTime date;

  /// Prayers ticked that day, 0-5.
  final int count;
}

DateTime firstOfMonth(DateTime d) => DateTime(d.year, d.month);

DateTime addMonths(DateTime month, int delta) => DateTime(month.year, month.month + delta);

int daysInMonth(DateTime month) => DateTime(month.year, month.month + 1, 0).day;

/// Rows of 7 cells, Monday first. Days outside the month are null.
List<List<MonthCell?>> buildMonthGrid(DateTime month, Map<DateTime, int> counts) {
  final first = firstOfMonth(month);
  final leading = first.weekday - 1; // Monday = 1
  final cells = <MonthCell?>[
    for (var i = 0; i < leading; i++) null,
    for (var day = 1; day <= daysInMonth(first); day++)
      MonthCell(
        date: DateTime(first.year, first.month, day),
        count: (counts[DateTime(first.year, first.month, day)] ?? 0).clamp(0, 5),
      ),
  ];
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return [for (var i = 0; i < cells.length; i += 7) cells.sublist(i, i + 7)];
}

/// Shade level 0 (nothing) to 4 (all five prayers).
int heatLevel(int count) {
  if (count <= 0) return 0;
  if (count >= 5) return 4;
  if (count >= 4) return 3;
  if (count >= 2) return 2;
  return 1;
}
