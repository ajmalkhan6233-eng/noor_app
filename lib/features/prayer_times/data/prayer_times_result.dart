// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The typed outcome of a prayer-time calculation. At extreme
// latitudes/dates a true Isha (and sometimes Fajr) may not exist —
// callers must handle [HighLatitudeUnresolved] explicitly instead of
// ever falling back to a guessed or interpolated clock time.

import 'package:equatable/equatable.dart';

/// Result of [PrayerRepository.calculate] — either a full set of
/// computed times, or an explicit high-latitude failure.
sealed class PrayerTimesResult extends Equatable {
  const PrayerTimesResult();
}

/// Five daily prayers plus sunrise, all successfully computed.
class PrayerTimesComputed extends PrayerTimesResult {
  const PrayerTimesComputed({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  /// The five daily prayers (excluding sunrise) in chronological order.
  List<(String name, DateTime time)> get prayerEntries => [
    ('Fajr', fajr),
    ('Dhuhr', dhuhr),
    ('Asr', asr),
    ('Maghrib', maghrib),
    ('Isha', isha),
  ];

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha];
}

/// The chosen calculation method could not resolve a genuine Isha (and
/// possibly Fajr) for this coordinate/date — e.g. inside the polar
/// circle during the season of continuous daylight or twilight. There
/// is no fabricated fallback time; the UI must say so plainly.
class HighLatitudeUnresolved extends PrayerTimesResult {
  const HighLatitudeUnresolved();

  @override
  List<Object?> get props => [];
}
