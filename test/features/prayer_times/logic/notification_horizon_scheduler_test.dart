// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression coverage for the 2026-08-26 fix: notifications used to
// be scheduled for "today" only, so on any day the app wasn't opened,
// that day silently had no notification at all. This tests that the
// horizon actually spans multiple distinct days, using each day's own
// freshly-computed times, and that day 0 reuses state.result rather
// than recomputing.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/features/prayer_times/data/adhan_reciter.dart';
import 'package:noor/features/prayer_times/data/notification_slots.dart';
import 'package:noor/features/prayer_times/data/prayer_notification_coordinator.dart';
import 'package:noor/features/prayer_times/data/prayer_repository.dart';
import 'package:noor/features/prayer_times/data/prayer_settings.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_times/logic/prayer_cubit/notification_horizon_scheduler.dart';
import 'package:noor/features/prayer_times/logic/prayer_cubit/prayer_state.dart';

class _RecordingCoordinator extends PrayerNotificationCoordinator {
  final List<int> dayOffsetsScheduled = [];
  final List<PrayerTimesComputed> timesScheduled = [];

  @override
  Future<void> scheduleForDay({
    required PrayerTimesComputed times,
    required dynamic notifications,
    required dynamic iqamathOffsets,
    required dynamic silentMode,
    bool preReminderEnabled = false,
    int preReminderMinutes = 10,
    int dayOffset = 0,
    AdhanReciter reciter = AdhanReciter.doha,
  }) async {
    dayOffsetsScheduled.add(dayOffset);
    timesScheduled.add(times);
  }
}

void main() {
  const coordinates = Coordinates(latitude: 6.9271, longitude: 79.8612);
  const repository = PrayerRepository();

  test('schedules one call per day across the full horizon', () async {
    final today = DateTime(2026, 6, 1);
    final todayResult = repository.calculate(
      coordinates: coordinates,
      date: today,
      settings: const PrayerSettings(),
    );
    final state = PrayerState(
      date: today,
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      result: todayResult,
    );
    final coordinator = _RecordingCoordinator();

    await scheduleNotificationHorizon(
      repository: repository,
      notificationCoordinator: coordinator,
      state: state,
      coordinates: coordinates,
    );

    expect(
      coordinator.dayOffsetsScheduled,
      List.generate(notificationSchedulingHorizonDays, (i) => i),
    );
  });

  test('day 0 reuses state.result rather than recomputing it', () async {
    final today = DateTime(2026, 6, 1);
    final todayResult = repository.calculate(
      coordinates: coordinates,
      date: today,
      settings: const PrayerSettings(),
    );
    final state = PrayerState(
      date: today,
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      result: todayResult,
    );
    final coordinator = _RecordingCoordinator();

    await scheduleNotificationHorizon(
      repository: repository,
      notificationCoordinator: coordinator,
      state: state,
      coordinates: coordinates,
    );

    expect(coordinator.timesScheduled.first, same(todayResult));
  });

  test('later days use their own distinct, correctly-dated times', () async {
    final today = DateTime(2026, 6, 1);
    final todayResult = repository.calculate(
      coordinates: coordinates,
      date: today,
      settings: const PrayerSettings(),
    ) as PrayerTimesComputed;
    final state = PrayerState(
      date: today,
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      result: todayResult,
    );
    final coordinator = _RecordingCoordinator();

    await scheduleNotificationHorizon(
      repository: repository,
      notificationCoordinator: coordinator,
      state: state,
      coordinates: coordinates,
    );

    final tomorrow = coordinator.timesScheduled[1];
    // `adhan`'s PrayerTimes converts via .toLocal(), i.e. the *host
    // machine's* timezone, not a timezone derived from the passed
    // coordinates — harmless on a real device (whose local timezone
    // matches wherever its owner actually is), but it means a plain
    // `.day` comparison is only correct when the machine running this
    // test happens to share Colombo's UTC+5:30 offset. On a CI runner
    // (UTC), an early-morning Colombo Fajr for "tomorrow" lands on
    // UTC's *previous* calendar day — deterministically, not flakily.
    // DateTime.difference() compares the actual instants regardless of
    // which timezone each side displays itself in, so this checks the
    // real invariant (tomorrow's Fajr is a genuinely distinct
    // computation, roughly a day later) without assuming the test
    // runner's own timezone.
    final gap = tomorrow.fajr.difference(todayResult.fajr);
    expect(gap.inMinutes, greaterThan(23 * 60));
    expect(gap.inMinutes, lessThan(25 * 60));
    expect(tomorrow, isNot(same(todayResult)));
  });
}
