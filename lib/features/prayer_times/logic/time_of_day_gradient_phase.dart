// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure computation for the Home countdown header's 5 time-of-day
// gradient states — night, dawn, day, afternoon, evening — derived
// from the same [PrayerTimesComputed] markers PrayerHero already
// uses for its countdown. No separate prayer-time math: this only
// buckets `now` against fajr/sunrise/asr/maghrib/isha, which are
// already computed once by PrayerCubit and passed down.

import '../data/prayer_times_result.dart';

enum TimeOfDayGradientPhase { night, dawn, day, afternoon, evening }

TimeOfDayGradientPhase computeTimeOfDayGradientPhase({
  required PrayerTimesComputed times,
  required DateTime now,
}) {
  if (now.isBefore(times.fajr)) return TimeOfDayGradientPhase.night;
  if (now.isBefore(times.sunrise)) return TimeOfDayGradientPhase.dawn;
  if (now.isBefore(times.asr)) return TimeOfDayGradientPhase.day;
  if (now.isBefore(times.maghrib)) return TimeOfDayGradientPhase.afternoon;
  if (now.isBefore(times.isha)) return TimeOfDayGradientPhase.evening;
  return TimeOfDayGradientPhase.night;
}
