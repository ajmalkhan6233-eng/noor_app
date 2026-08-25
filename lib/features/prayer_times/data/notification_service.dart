// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Local-only adhan/iqamath/reminder notifications — `zonedSchedule`
// fires entirely on-device via AlarmManager, no server, no push
// token, no network. Only this file touches
// `flutter_local_notifications`; id/slot mapping lives in
// notification_slots.dart to keep this file under the line limit.
//
// The adhan notification plays the actual adhan recording, not a
// generic beep — Android ties a notification's sound to its channel
// (immutable once created), so each prayer gets its own channel
// pointing at its own android/app/src/main/res/raw/adhan_<prayer>.mp3
// (copied there from the existing assets/audio/adhan/ bundle
// specifically for this — Flutter assets aren't reachable as a raw
// Android notification sound resource). Previously every prayer
// shared one generic 'prayer_times' channel with no sound override,
// so what actually fired was just the phone's default notification
// tone — a real, silent-adhan-shaped bug, not a hypothetical one.

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

  /// Fires the real adhan notification for [slot] immediately, through
  /// the exact same channel a scheduled prayer-time notification uses
  /// — lets someone confirm right now, from Settings, that it actually
  /// plays and isn't silenced by a system-level Do Not Disturb rule or
  /// per-app notification setting, rather than finding out at the next
  /// missed prayer.
  Future<void> showTestNotification(PrayerSlot slot) async {
    await initialize();
    final name = slotLabel(slot);
    await _plugin.show(
      9000 + slot.index,
      '$name adhan (test)',
      'This is what the $name adhan notification sounds like.',
      _adhanNotificationDetails(slot),
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
      await _scheduleAt(
        slot,
        '$name adhan',
        'It is time for $name.',
        adhanTime,
        details: _adhanNotificationDetails(slot),
      );

      final iqamathMinutes = iqamathOffsets.forPrayer(name);
      final iqamathTime = adhanTime.add(Duration(minutes: iqamathMinutes));
      await _scheduleAt(
        slot,
        '$name iqamath',
        'Congregation for $name is starting.',
        iqamathTime,
        kind: NotificationKind.iqamath,
        details: _defaultNotificationDetails,
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
          details: _defaultNotificationDetails,
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
    required NotificationDetails details,
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
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static const NotificationDetails _defaultNotificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'prayer_times',
      'Prayer times',
      channelDescription: 'Iqamath and pre-adhan reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  /// One channel per prayer (`prayer_adhan_<name>`) so each can carry
  /// its own actual adhan recording as the channel sound — Android
  /// notification channels are created once and their sound can never
  /// be changed afterward, which is why this can't just be a `sound:`
  /// override on the shared channel above.
  NotificationDetails _adhanNotificationDetails(PrayerSlot slot) {
    final key = slot.name;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_adhan_$key',
        '${_capitalize(key)} adhan',
        channelDescription: 'The $key call to prayer',
        importance: Importance.max,
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound('adhan_$key'),
        playSound: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
