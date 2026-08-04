// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Composes NotificationService (adhan/iqamath reminders) and
// SilentModeChannel (ringer scheduling) behind one call, so
// PrayerCubit only needs a single hook whenever the day's times are
// (re)computed.

import '../../settings/data/notification_settings.dart';
import 'iqamath_offsets.dart';
import 'notification_service.dart';
import 'prayer_times_result.dart';
import 'silent_mode_channel.dart';
import 'silent_mode_settings.dart';

class PrayerNotificationCoordinator {
  PrayerNotificationCoordinator({
    NotificationService? notificationService,
    SilentModeChannel? silentModeChannel,
  }) : _notifications = notificationService ?? NotificationService(),
       _silentMode = silentModeChannel ?? const SilentModeChannel();

  final NotificationService _notifications;
  final SilentModeChannel _silentMode;

  /// Schedules everything for [times]: an adhan/iqamath notification
  /// per enabled prayer, and a silent-ringer window for every prayer
  /// with Silent Mode on.
  Future<void> scheduleForDay({
    required PrayerTimesComputed times,
    required NotificationSettings notifications,
    required IqamathOffsetMinutes iqamathOffsets,
    required SilentModeSettings silentMode,
  }) async {
    await _notifications.scheduleForDay(
      times: times,
      notifications: notifications,
      iqamathOffsets: iqamathOffsets,
    );
    await _scheduleSilentWindows(times, iqamathOffsets, silentMode);
  }

  Future<void> _scheduleSilentWindows(
    PrayerTimesComputed times,
    IqamathOffsetMinutes iqamathOffsets,
    SilentModeSettings silentMode,
  ) async {
    var index = 0;
    for (final (name, adhanTime) in times.prayerEntries) {
      // Each window uses 2 native alarm request codes (silence,
      // restore — see MainActivity.scheduleSilentWindow), so codes
      // must be spaced by 2 to avoid PendingIntent collisions.
      final requestCode = 500 + index * 2;
      index++;
      if (!silentMode.forPrayer(name)) {
        await _silentMode.cancelSilentWindow(requestCode);
        continue;
      }
      final iqamathTime = adhanTime.add(
        Duration(minutes: iqamathOffsets.forPrayer(name)),
      );
      final end = iqamathTime.add(
        Duration(minutes: silentMode.extraMinutesAfterIqamath),
      );
      if (end.isBefore(DateTime.now())) {
        await _silentMode.cancelSilentWindow(requestCode);
        continue;
      }
      await _silentMode.scheduleSilentWindow(
        start: adhanTime,
        end: end,
        requestCode: requestCode,
      );
    }
  }
}
