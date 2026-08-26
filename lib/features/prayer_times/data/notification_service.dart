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

import '../../settings/data/notification_settings.dart';
import 'iqamath_offsets.dart';
import 'notification_details.dart';
import 'notification_scheduling.dart';
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
    // Android 13+ (API 33+): a notification permission that's granted
    // or denied at runtime, separate from (and a prerequisite to) the
    // exact-alarm grant below — without this, .show()/.zonedSchedule()
    // both silently do nothing, no exception, no log. Requesting on
    // every initialize() is harmless once already granted/denied; this
    // is the only place that ever asks, so it has to run somewhere
    // reachable before the very first notification of any kind.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
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
      adhanNotificationDetails(slot),
    );
  }

  /// Schedules adhan/iqamath/reminder notifications for every enabled
  /// prayer in [times], respecting [notifications]' per-prayer toggle.
  /// Sunrise never gets a notification. The pre-adhan reminder is a
  /// single global on/off + minutes value, not per-prayer.
  ///
  /// [dayOffset] (0 = today) is the caller's responsibility to loop
  /// across the full [notificationSchedulingHorizonDays] — this method
  /// only ever touches the one day it's given, so a disabled prayer is
  /// only fully cleared across every future day if the caller cancels
  /// (or reschedules) every offset in the horizon, not just today's.
  Future<void> scheduleForDay({
    required PrayerTimesComputed times,
    required NotificationSettings notifications,
    required IqamathOffsetMinutes iqamathOffsets,
    bool preReminderEnabled = false,
    int preReminderMinutes = 10,
    int dayOffset = 0,
  }) async {
    await initialize();
    for (final slot in PrayerSlot.values) {
      final (name, adhanTime) = entryForSlot(slot, times);
      if (!notifications.forPrayer(name)) {
        await cancelSlot(_plugin, slot, dayOffset: dayOffset);
        continue;
      }
      await scheduleAt(
        _plugin,
        slot,
        '$name adhan',
        'It is time for $name.',
        adhanTime,
        details: adhanNotificationDetails(slot),
        dayOffset: dayOffset,
      );

      final iqamathMinutes = iqamathOffsets.forPrayer(name);
      final iqamathTime = adhanTime.add(Duration(minutes: iqamathMinutes));
      await scheduleAt(
        _plugin,
        slot,
        '$name iqamath',
        'Congregation for $name is starting.',
        iqamathTime,
        kind: NotificationKind.iqamath,
        details: defaultNotificationDetails,
        dayOffset: dayOffset,
      );

      if (preReminderEnabled) {
        final reminderTime = adhanTime.subtract(
          Duration(minutes: preReminderMinutes),
        );
        await scheduleAt(
          _plugin,
          slot,
          '$name in $preReminderMinutes min',
          '$name will be at ${formatClockTime(adhanTime)}.',
          reminderTime,
          kind: NotificationKind.reminder,
          details: defaultNotificationDetails,
          dayOffset: dayOffset,
        );
      } else {
        await _plugin.cancel(
          idForSlot(slot, kind: NotificationKind.reminder, dayOffset: dayOffset),
        );
      }
    }
  }
}
