// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The actual per-notification schedule/cancel primitives, split out
// of notification_service.dart to stay under the 150-line-per-file
// rule. Both take the plugin instance directly rather than being
// NotificationService methods.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_schedule_mode.dart';
import 'notification_slots.dart';

Future<void> cancelSlot(
  FlutterLocalNotificationsPlugin plugin,
  PrayerSlot slot, {
  int dayOffset = 0,
}) async {
  for (final kind in NotificationKind.values) {
    await plugin.cancel(idForSlot(slot, kind: kind, dayOffset: dayOffset));
  }
}

Future<void> scheduleAt(
  FlutterLocalNotificationsPlugin plugin,
  PrayerSlot slot,
  String title,
  String body,
  DateTime time, {
  NotificationKind kind = NotificationKind.adhan,
  int dayOffset = 0,
  required NotificationDetails details,
}) async {
  final id = idForSlot(slot, kind: kind, dayOffset: dayOffset);
  final scheduled = tz.TZDateTime.from(time, tz.local);
  if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
    await plugin.cancel(id);
    return;
  }
  await plugin.zonedSchedule(
    id,
    title,
    body,
    scheduled,
    details,
    androidScheduleMode: await resolveScheduleMode(
      plugin,
      preferAlarmClock: kind == NotificationKind.adhan,
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
