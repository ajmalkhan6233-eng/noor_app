// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Local-only adhan/iqamath reminders — `zonedSchedule` fires entirely
// on-device via AlarmManager, no server, no push token, no network.
// Only this file touches `flutter_local_notifications`.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../settings/data/notification_settings.dart';
import 'iqamath_offsets.dart';
import 'prayer_times_result.dart';

/// Notification ids are stable per-prayer so re-scheduling the same
/// day simply replaces the earlier alarm instead of stacking a new
/// one beside it.
enum _PrayerSlot { fajr, dhuhr, asr, maghrib, isha }

/// Schedules local "time to pray" notifications for adhan and, when an
/// iqamath offset exists, a second reminder at the congregation time.
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

  /// Schedules adhan (and iqamath, when it has an offset) notifications
  /// for every enabled prayer in [times], respecting [notifications]'
  /// per-prayer toggle. Sunrise never gets a notification.
  Future<void> scheduleForDay({
    required PrayerTimesComputed times,
    required NotificationSettings notifications,
    required IqamathOffsetMinutes iqamathOffsets,
  }) async {
    await initialize();
    for (final slot in _PrayerSlot.values) {
      final (name, adhanTime) = _entryFor(slot, times);
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
        isIqamath: true,
      );
    }
  }

  (String, DateTime) _entryFor(_PrayerSlot slot, PrayerTimesComputed t) {
    return switch (slot) {
      _PrayerSlot.fajr => ('Fajr', t.fajr),
      _PrayerSlot.dhuhr => ('Dhuhr', t.dhuhr),
      _PrayerSlot.asr => ('Asr', t.asr),
      _PrayerSlot.maghrib => ('Maghrib', t.maghrib),
      _PrayerSlot.isha => ('Isha', t.isha),
    };
  }

  int _idFor(_PrayerSlot slot, {bool isIqamath = false}) =>
      slot.index * 2 + (isIqamath ? 1 : 0);

  Future<void> _cancel(_PrayerSlot slot) async {
    await _plugin.cancel(_idFor(slot));
    await _plugin.cancel(_idFor(slot, isIqamath: true));
  }

  Future<void> _scheduleAt(
    _PrayerSlot slot,
    String title,
    String body,
    DateTime time, {
    bool isIqamath = false,
  }) async {
    final id = _idFor(slot, isIqamath: isIqamath);
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
