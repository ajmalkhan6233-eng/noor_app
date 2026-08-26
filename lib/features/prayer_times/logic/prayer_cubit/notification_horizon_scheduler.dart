// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of prayer_cubit.dart to stay under the 150-line-per-file
// rule. Schedules notifications several days ahead, not just today —
// a real gap found 2026-08-26: with only today ever scheduled, every
// notification silently went missing on any day the app wasn't
// opened, not just after a reboot (the plugin's own boot receiver
// already handles that case correctly). See
// notificationSchedulingHorizonDays' own doc comment for the exact
// horizon length and id-spacing reasoning.

import '../../../../core/location/location_service.dart';
import '../../data/notification_slots.dart';
import '../../data/prayer_notification_coordinator.dart';
import '../../data/prayer_repository.dart';
import '../../data/prayer_times_result.dart';
import 'prayer_state.dart';

Future<void> scheduleNotificationHorizon({
  required PrayerRepository repository,
  required PrayerNotificationCoordinator notificationCoordinator,
  required PrayerState state,
  required Coordinates coordinates,
}) async {
  for (var dayOffset = 0; dayOffset < notificationSchedulingHorizonDays; dayOffset++) {
    final dayResult = dayOffset == 0
        ? state.result
        : repository.calculate(
            coordinates: coordinates,
            date: state.date.add(Duration(days: dayOffset)),
            settings: state.settings,
          );
    if (dayResult is! PrayerTimesComputed) continue;
    await notificationCoordinator
        .scheduleForDay(
          times: dayResult,
          notifications: state.notifications,
          iqamathOffsets: state.iqamathOffsets,
          silentMode: state.silentMode,
          preReminderEnabled: state.preReminderEnabled,
          preReminderMinutes: state.preReminderMinutes,
          dayOffset: dayOffset,
        )
        .catchError((_) {});
  }
}
