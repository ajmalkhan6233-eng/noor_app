// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of notification_service.dart to stay under the
// 150-line-per-file rule.
//
// Android 12+ gates *exact* alarms behind a separate "Alarms &
// reminders" grant that isn't the same as notification permission and
// isn't auto-granted just because SCHEDULE_EXACT_ALARM is in the
// manifest — some OEMs (Xiaomi/MIUI especially) require the user to
// flip it on manually. Every scheduled call used to use
// `exactAllowWhileIdle` unconditionally, and the whole scheduling
// chain is wrapped in a blanket `.catchError` up in PrayerCubit — so
// on a device where that grant is missing, every adhan/iqamath/
// reminder notification silently failed to schedule, with nothing
// surfaced anywhere (reported live: "reminder set, nothing fired").
// The native Silent Mode alarms already had this exact fallback (see
// MainActivity.kt's setAlarm); this brings the Dart-side notifications
// in line with it rather than failing silently.
//
// [preferAlarmClock] asks for `AndroidScheduleMode.alarmClock` — used
// only for the adhan itself, not iqamath/reminder notifications.
// `alarmClock` is what a genuine alarm-clock app uses: it shows in the
// system's "next alarm" indicator and is significantly harder for OEM
// battery-management layers (MIUI/Samsung/Huawei) to suppress than a
// plain exact alarm. This plugin's own implementation (verified
// against the installed 17.2.4 source) still requires the exact-alarm
// grant for `alarmClock` — it is not a free pass around that
// permission — so this only ever asks for it when
// canScheduleExactNotifications() is already true; otherwise it falls
// back exactly as before.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<AndroidScheduleMode> resolveScheduleMode(
  FlutterLocalNotificationsPlugin plugin, {
  bool preferAlarmClock = false,
}) async {
  final androidPlugin = plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  final canExact = await androidPlugin?.canScheduleExactNotifications();
  if (canExact == false) return AndroidScheduleMode.inexactAllowWhileIdle;
  return preferAlarmClock
      ? AndroidScheduleMode.alarmClock
      : AndroidScheduleMode.exactAllowWhileIdle;
}
