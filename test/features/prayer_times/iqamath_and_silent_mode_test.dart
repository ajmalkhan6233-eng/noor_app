// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/iqamath_offsets.dart';
import 'package:noor/features/prayer_times/data/notification_service.dart';
import 'package:noor/features/prayer_times/data/prayer_notification_coordinator.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_times/data/silent_mode_channel.dart';
import 'package:noor/features/prayer_times/data/silent_mode_settings.dart';
import 'package:noor/features/settings/data/notification_settings.dart';

/// Records scheduled windows instead of touching the native
/// `com.noorapp.noor/silent_mode` MethodChannel — no platform channel
/// is available in this offline unit-test environment.
class _FakeSilentModeChannel extends SilentModeChannel {
  const _FakeSilentModeChannel(this.scheduled, this.cancelled);

  final List<({DateTime start, DateTime end, int requestCode})> scheduled;
  final List<int> cancelled;

  @override
  Future<void> scheduleSilentWindow({
    required DateTime start,
    required DateTime end,
    required int requestCode,
  }) async {
    scheduled.add((start: start, end: end, requestCode: requestCode));
  }

  @override
  Future<void> cancelSilentWindow(int requestCode) async {
    cancelled.add(requestCode);
  }
}

/// No-op notification scheduling — this test only exercises the
/// silent-mode window computation.
class _NoopNotificationService extends NotificationService {
  @override
  Future<void> scheduleForDay({
    required PrayerTimesComputed times,
    required NotificationSettings notifications,
    required IqamathOffsetMinutes iqamathOffsets,
  }) async {}
}

void main() {
  group('IqamathOffsetMinutes', () {
    test('forPrayer returns the matching field', () {
      const offsets = IqamathOffsetMinutes(fajr: 25, isha: 12);
      expect(offsets.forPrayer('Fajr'), 25);
      expect(offsets.forPrayer('Isha'), 12);
      expect(offsets.forPrayer('Sunrise'), 0);
    });

    test('copyWith changes only the requested prayer', () {
      const original = IqamathOffsetMinutes();
      final updated = original.copyWith(dhuhr: 5);
      expect(updated.dhuhr, 5);
      expect(updated.fajr, original.fajr);
    });
  });

  group('SilentModeSettings', () {
    test('forPrayer reflects each toggle independently', () {
      const settings = SilentModeSettings(fajr: true, isha: true);
      expect(settings.forPrayer('Fajr'), isTrue);
      expect(settings.forPrayer('Dhuhr'), isFalse);
      expect(settings.forPrayer('Isha'), isTrue);
    });
  });

  group('PrayerNotificationCoordinator silent-window scheduling', () {
    // A fixed date far in the future so "is this window still ahead of
    // now" logic in the coordinator never makes this test time-flaky.
    final future = DateTime.now().add(const Duration(days: 365));
    final times = PrayerTimesComputed(
      fajr: DateTime(future.year, future.month, future.day, 4, 30),
      sunrise: DateTime(future.year, future.month, future.day, 5, 50),
      dhuhr: DateTime(future.year, future.month, future.day, 12, 15),
      asr: DateTime(future.year, future.month, future.day, 15, 45),
      maghrib: DateTime(future.year, future.month, future.day, 18, 30),
      isha: DateTime(future.year, future.month, future.day, 19, 45),
    );

    test(
      'schedules a window from adhan to iqamath + extra minutes for '
      'enabled prayers only',
      () async {
        final scheduled = <({DateTime start, DateTime end, int requestCode})>[];
        final cancelled = <int>[];
        final coordinator = PrayerNotificationCoordinator(
          notificationService: _NoopNotificationService(),
          silentModeChannel: _FakeSilentModeChannel(scheduled, cancelled),
        );

        await coordinator.scheduleForDay(
          times: times,
          notifications: const NotificationSettings(),
          iqamathOffsets: const IqamathOffsetMinutes(fajr: 20),
          silentMode: const SilentModeSettings(
            fajr: true,
            extraMinutesAfterIqamath: 5,
          ),
        );

        // Fajr is the first prayer entry (index 0) => request code 500.
        final fajrWindow = scheduled.firstWhere((w) => w.requestCode == 500);
        expect(fajrWindow.start, times.fajr);
        expect(
          fajrWindow.end,
          times.fajr.add(const Duration(minutes: 20 + 5)),
        );

        // Every other prayer is disabled, so all other request codes
        // (spaced by 2: 502, 504, 506, 508) should be cancelled, never
        // scheduled.
        expect(scheduled.length, 1);
        expect(cancelled, containsAll([502, 504, 506, 508]));
      },
    );
  });
}
