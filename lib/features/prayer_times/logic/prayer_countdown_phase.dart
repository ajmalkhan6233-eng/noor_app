// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure computation, deliberately kept out of any widget: given the
// day's prayer times, the user's per-prayer iqamah offsets, and the
// current moment, decide which of two states the Home countdown
// should show. A widget only calls [computePrayerCountdownPhase] and
// renders whichever branch comes back — the actual "when does the
// state change" logic lives here so it can be unit tested against a
// clock without pumping a widget tree.

import '../data/iqamath_offsets.dart';
import '../data/prayer_times_result.dart';

sealed class PrayerCountdownPhase {
  const PrayerCountdownPhase();
}

/// Ordinary state: counting down to the next prayer's adhan. This is
/// also what's shown before Fajr and in the gap after a prayer's own
/// iqamah has passed but the next prayer's adhan hasn't happened yet.
class NextPrayerPhase extends PrayerCountdownPhase {
  const NextPrayerPhase({
    required this.prayerName,
    required this.adhanTime,
    required this.remaining,
  });

  final String prayerName;
  final DateTime adhanTime;
  final Duration remaining;
}

/// Active only between a prayer's adhan and its iqamah — the window
/// requested directly: "Head to the masjid" instead of already
/// counting down to whatever comes next.
class IqamaGapPhase extends PrayerCountdownPhase {
  const IqamaGapPhase({
    required this.prayerName,
    required this.iqamahTime,
    required this.remaining,
  });

  final String prayerName;
  final DateTime iqamahTime;
  final Duration remaining;
}

PrayerCountdownPhase computePrayerCountdownPhase({
  required PrayerTimesComputed times,
  required IqamathOffsetMinutes offsets,
  required DateTime now,
}) {
  (String, DateTime)? lastPassed;
  for (final entry in times.prayerEntries) {
    if (!entry.$2.isAfter(now)) {
      lastPassed = entry;
    } else {
      // First entry still in the future — this is the next adhan,
      // unless the previous prayer's iqamah gap is still open.
      if (lastPassed != null) {
        final iqamah = lastPassed.$2.add(
          Duration(minutes: offsets.forPrayer(lastPassed.$1)),
        );
        if (iqamah.isAfter(now)) {
          return IqamaGapPhase(
            prayerName: lastPassed.$1,
            iqamahTime: iqamah,
            remaining: iqamah.difference(now),
          );
        }
      }
      return NextPrayerPhase(
        prayerName: entry.$1,
        adhanTime: entry.$2,
        remaining: entry.$2.difference(now),
      );
    }
  }

  // Every prayer's adhan today has passed — check Isha's own iqamah
  // gap before falling through to tomorrow's Fajr.
  if (lastPassed != null) {
    final iqamah = lastPassed.$2.add(
      Duration(minutes: offsets.forPrayer(lastPassed.$1)),
    );
    if (iqamah.isAfter(now)) {
      return IqamaGapPhase(
        prayerName: lastPassed.$1,
        iqamahTime: iqamah,
        remaining: iqamah.difference(now),
      );
    }
  }

  // Only today's computed times are available here, so tomorrow's
  // Fajr is approximated as the same clock time one day later —
  // prayer times shift by at most a couple of minutes day-to-day,
  // close enough for a live countdown (matches PrayerHero's prior
  // after-Isha handling).
  final tomorrowFajr = times.fajr.add(const Duration(days: 1));
  return NextPrayerPhase(
    prayerName: 'Fajr',
    adhanTime: tomorrowFajr,
    remaining: tomorrowFajr.difference(now),
  );
}
