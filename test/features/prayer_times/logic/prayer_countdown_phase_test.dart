// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Unit tests for the Iqama-gap state machine: Adhan time reached ->
// Iqama countdown phase -> gap expires -> back to next-prayer phase.
// Pure function, no widget pumping needed.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/iqamath_offsets.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_times/logic/prayer_countdown_phase.dart';

void main() {
  final times = PrayerTimesComputed(
    fajr: DateTime(2026, 1, 1, 5, 0),
    sunrise: DateTime(2026, 1, 1, 6, 30),
    dhuhr: DateTime(2026, 1, 1, 12, 0),
    asr: DateTime(2026, 1, 1, 15, 0),
    maghrib: DateTime(2026, 1, 1, 18, 0),
    isha: DateTime(2026, 1, 1, 19, 30),
  );
  const offsets = IqamathOffsetMinutes(
    fajr: 20,
    dhuhr: 10,
    asr: 10,
    maghrib: 5,
    isha: 10,
  );

  test('before any adhan today, counts down to Fajr as NextPrayerPhase', () {
    final phase = computePrayerCountdownPhase(
      times: times,
      offsets: offsets,
      now: DateTime(2026, 1, 1, 4, 0),
    );
    expect(phase, isA<NextPrayerPhase>());
    expect((phase as NextPrayerPhase).prayerName, 'Fajr');
    expect(phase.remaining, const Duration(hours: 1));
  });

  test('the instant an adhan time is reached, switches to IqamaGapPhase', () {
    final phase = computePrayerCountdownPhase(
      times: times,
      offsets: offsets,
      now: DateTime(2026, 1, 1, 12, 0), // exactly Dhuhr
    );
    expect(phase, isA<IqamaGapPhase>());
    expect((phase as IqamaGapPhase).prayerName, 'Dhuhr');
    expect(phase.iqamahTime, DateTime(2026, 1, 1, 12, 10));
    expect(phase.remaining, const Duration(minutes: 10));
  });

  test('stays in IqamaGapPhase with a shrinking countdown mid-gap', () {
    final phase = computePrayerCountdownPhase(
      times: times,
      offsets: offsets,
      now: DateTime(2026, 1, 1, 12, 6),
    );
    expect(phase, isA<IqamaGapPhase>());
    expect((phase as IqamaGapPhase).remaining, const Duration(minutes: 4));
  });

  test(
    'the instant the iqamah gap expires, returns to NextPrayerPhase for the '
    'following prayer',
    () {
      final phase = computePrayerCountdownPhase(
        times: times,
        offsets: offsets,
        now: DateTime(2026, 1, 1, 12, 10), // Dhuhr adhan + 10 min offset
      );
      expect(phase, isA<NextPrayerPhase>());
      expect((phase as NextPrayerPhase).prayerName, 'Asr');
      expect(phase.remaining, const Duration(hours: 2, minutes: 50));
    },
  );

  test('a zero-minute offset never opens an Iqama gap', () {
    const zeroOffsets = IqamathOffsetMinutes(
      fajr: 0,
      dhuhr: 0,
      asr: 0,
      maghrib: 0,
      isha: 0,
    );
    final phase = computePrayerCountdownPhase(
      times: times,
      offsets: zeroOffsets,
      now: DateTime(2026, 1, 1, 12, 0),
    );
    expect(phase, isA<NextPrayerPhase>());
    expect((phase as NextPrayerPhase).prayerName, 'Asr');
  });

  test('Isha\'s own iqamah gap is honoured before falling through to Fajr', () {
    final phase = computePrayerCountdownPhase(
      times: times,
      offsets: offsets,
      now: DateTime(2026, 1, 1, 19, 35), // Isha adhan + 5 min
    );
    expect(phase, isA<IqamaGapPhase>());
    expect((phase as IqamaGapPhase).prayerName, 'Isha');
    expect(phase.remaining, const Duration(minutes: 5));
  });

  test('after Isha\'s iqamah gap closes, counts down to tomorrow\'s Fajr', () {
    final phase = computePrayerCountdownPhase(
      times: times,
      offsets: offsets,
      now: DateTime(2026, 1, 1, 19, 40), // Isha adhan + 10 min offset
    );
    expect(phase, isA<NextPrayerPhase>());
    expect((phase as NextPrayerPhase).prayerName, 'Fajr');
    expect(phase.adhanTime, DateTime(2026, 1, 2, 5, 0));
  });
}
