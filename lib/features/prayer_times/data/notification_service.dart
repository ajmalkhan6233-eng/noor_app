// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Local-only adhan/iqamath/reminder notifications — `zonedSchedule`
// fires entirely on-device via AlarmManager, no server, no push
// token, no network. Only this file touches
// `flutter_local_notifications`; id/slot mapping lives in
// notification_slots.dart to keep this file under the line limit.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../settings/data/notification_settings.dart';
import 'iqamath_offsets.dart';
import 'notification_slots.dart';
import 'prayer_times_result.dart';

/// Schedules local "time to pray" notifications for adhan, iqamath
/// (when it has an offset), and an optional reminder before adhan.
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static bool _tzReady = false;

  /// Initializes the plugin and timezone database. Safe to call more
  /// than once — later calls are no-ops.
  Future<void> initialize() async {
    if (!_tzReady) {
      tz_data.initializeTimeZones();
      _tzReady = true;
    }
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: androidInit),
    );
  }

  /// Schedules adhan/iqamath/reminder notifications for every enabled
  /// prayer in [times], respecting [notifications]' per-prayer toggle.
  /// Sunrise never gets a notification. The pre-adhan reminder is a
  /// single global on/off + minutes value, not per-prayer.
  Future<void> scheduleForDay({
    required PrayerTimesComputed times,
    required NotificationSettings notifications,
    required IqamathOffsetMinutes iqamathOffsets,
    bool preReminderEnabled = false,
    int preReminderMinutes = 10,
  }) async {
    await initialize();
    for (final slot in PrayerSlot.values) {
      final (name, adhanTime) = entryForSlot(slot, times);
      if (!notifications.forPrayer(name)) {
        await _cancel(slot);
        continue;
      }
      await _scheduleAt(slot, '$name adhan', 'It is time for $name.', adhanTime);

      final iqamathMinutes = iqamathOffsets.forPrayer(name);
      final iqamathTime = adhanTime.add(Duration(minutes: iqamathMinutes));
      await _scheduleAt(
        slot,
        '$name iqamath',
        'Congregation for $name is starting.',
        iqamathTime,
        kind: NotificationKind.iqamath,
      );

      if (preReminderEnabled) {
        final reminderTime = adhanTime.subtract(
          Duration(minutes: preReminderMinutes),
        );
        await _scheduleAt(
          slot,
          '$name in $preReminderMinutes min',
          '$name will be at ${formatClockTime(adhanTime)}.',
          reminderTime,
          kind: NotificationKind.reminder,
        );
      } else {
        await _plugin.cancel(idForSlot(slot, kind: NotificationKind.reminder));
      }
    }
  }

  Future<void> _cancel(PrayerSlot slot) async {
    for (final kind in NotificationKind.values) {
      await _plugin.cancel(idForSlot(slot, kind: kind));
    }
  }

  Future<void> _scheduleAt(
    PrayerSlot slot,
    String title,
    String body,
    DateTime time, {
    NotificationKind kind = NotificationKind.adhan,
  }) async {
    final id = idForSlot(slot, kind: kind);
    final scheduled = tz.TZDateTime.from(time, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      await _plugin.cancel(id);
      return;
    }
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_times',
          'Prayer times',
          channelDescription: 'Adhan and iqamath reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
