// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Notification channel/detail builders, split out of
// notification_service.dart to stay under the 150-line-per-file rule.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'adhan_reciter.dart';
import 'notification_slots.dart';

const NotificationDetails defaultNotificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    'prayer_times',
    'Prayer times',
    channelDescription: 'Iqamath and pre-adhan reminders',
    importance: Importance.high,
    priority: Priority.high,
    // Explicit, not left to the OS default — a prayer-time
    // notification has nothing sensitive in it, so it should show its
    // real content on a locked screen regardless of a given phone's
    // own global "hide sensitive notification content" setting.
    visibility: NotificationVisibility.public,
  ),
);

/// Its own channel, separate from [defaultNotificationDetails] — a
/// Calendar reminder isn't a prayer-time notification, and a person
/// may want to mute one channel without muting the other in Android's
/// own per-app notification settings.
const NotificationDetails calendarReminderNotificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    'calendar_reminders',
    'Calendar reminders',
    channelDescription: 'Reminders you set on the calendar',
    importance: Importance.high,
    priority: Priority.high,
  ),
);

/// One channel per (reciter, prayer) so each can carry its own actual
/// adhan recording as the channel sound — Android notification
/// channels are created once and their sound can never be changed
/// afterward, which is why this can't just be a `sound:` override on
/// the shared channel above, and why switching [reciter] must switch
/// to a differently-named channel rather than mutating the existing
/// one. `doha` (the original default) keeps its original channel id
/// (`prayer_adhan_<prayer>`) exactly as before, so nobody who never
/// touches the new setting gets a channel change; every other reciter
/// uses one raw resource for every prayer (see adhan_reciter.dart).
NotificationDetails adhanNotificationDetails(
  PrayerSlot slot, {
  AdhanReciter reciter = AdhanReciter.doha,
}) {
  final key = slot.name;
  final isDoha = reciter == AdhanReciter.doha;
  final channelId = isDoha ? 'prayer_adhan_$key' : 'prayer_adhan_${reciter.name}_$key';
  final soundResource = isDoha ? 'adhan_$key' : 'adhan_${reciter.name}';
  return NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      '${_capitalize(key)} adhan',
      channelDescription: 'The $key call to prayer',
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound(soundResource),
      playSound: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    ),
  );
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
