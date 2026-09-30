import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/logic/prayer_tick_guard.dart';

void main() {
  final today = DateTime(2026, 9, 30);
  final now = DateTime(2026, 9, 30, 12);
  final prayerStarts = <String, DateTime>{
    'Fajr': DateTime(2026, 9, 30, 5),
    'Dhuhr': DateTime(2026, 9, 30, 12),
    'Asr': DateTime(2026, 9, 30, 15),
    'Maghrib': DateTime(2026, 9, 30, 18),
    'Isha': DateTime(2026, 9, 30, 19, 7),
  };

  test('past day allows every prayer and future day allows none', () {
    for (final prayerStart in prayerStarts.values) {
      expect(
        canTickPrayer(
          viewedDate: today.subtract(const Duration(days: 1)),
          today: today,
          now: now,
          prayerStart: prayerStart,
        ),
        isTrue,
      );
      expect(
        canTickPrayer(
          viewedDate: today.add(const Duration(days: 1)),
          today: today,
          now: now,
          prayerStart: prayerStart,
        ),
        isFalse,
      );
    }
  });

  test('today allows each prayer only at or after its adhan', () {
    for (final prayerStart in prayerStarts.values) {
      expect(
        canTickPrayer(
          viewedDate: today,
          today: today,
          now: prayerStart.subtract(const Duration(seconds: 1)),
          prayerStart: prayerStart,
        ),
        isFalse,
      );
      expect(
        canTickPrayer(
          viewedDate: today,
          today: today,
          now: prayerStart,
          prayerStart: prayerStart,
        ),
        isTrue,
      );
    }
  });
}