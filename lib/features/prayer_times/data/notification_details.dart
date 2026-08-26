// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Notification channel/detail builders, split out of
// notification_service.dart to stay under the 150-line-per-file rule.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_slots.dart';

const NotificationDetails defaultNotificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    'prayer_times',
    'Prayer times',
    channelDescription: 'Iqamath and pre-adhan reminders',
    importance: Importance.high,
    priority: Priority.high,
  ),
);

/// One channel per prayer (`prayer_adhan_<name>`) so each can carry its
/// own actual adhan recording as the channel sound — Android
/// notification channels are created once and their sound can never be
/// changed afterward, which is why this can't just be a `sound:`
/// override on the shared channel above.
NotificationDetails adhanNotificationDetails(PrayerSlot slot) {
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
      category: AndroidNotificationCategory.alarm,
    ),
  );
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
