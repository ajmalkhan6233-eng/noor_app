// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Gregorian-to-Hijri conversion using the standard tabular (civil)
// Islamic calendar algorithm — pure arithmetic, no network, no bundled
// almanac data. This is an approximation of local moon-sighting by
// design; `AppSettings.hijriOffsetDays` exists precisely so a user can
// correct it for their own moon-sighting authority.

/// A single Hijri calendar date.
class HijriDate {
  const HijriDate({required this.year, required this.month, required this.day});

  final int year;
  final int month;
  final int day;

  static const List<String> monthNames = [
    'Muharram',
    'Safar',
    "Rabi' al-Awwal",
    "Rabi' al-Thani",
    'Jumada al-Awwal',
    'Jumada al-Thani',
    'Rajab',
    "Sha'ban",
    'Ramadan',
    'Shawwal',
    "Dhu al-Qi'dah",
    'Dhu al-Hijjah',
  ];

  String get monthName => monthNames[month - 1];

  String get formatted => '$day $monthName $year AH';

  /// Converts [date] (Gregorian) to Hijri, applying [offsetDays] (see
  /// `AppSettings.hijriOffsetDays`) before conversion.
  factory HijriDate.fromGregorian(DateTime date, {int offsetDays = 0}) {
    final jdn = _gregorianToJulianDayNumber(date) + offsetDays;
    return _julianDayNumberToHijri(jdn);
  }

  static int _gregorianToJulianDayNumber(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  static HijriDate _julianDayNumberToHijri(int jdn) {
    const islamicEpoch = 1948440;
    var l = jdn - islamicEpoch + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;
    return HijriDate(year: year, month: month, day: day);
  }
}
