// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure id/slot mapping split out of notification_service.dart to keep
// that file under the project's line-count convention — no plugin
// dependency here, just which prayer+kind maps to which stable alarm
// id and title/body text.

import 'prayer_times_result.dart';

/// Notification ids are stable per-prayer so re-scheduling the same
/// day simply replaces the earlier alarm instead of stacking a new
/// one beside it.
enum PrayerSlot { fajr, dhuhr, asr, maghrib, isha }

enum NotificationKind { adhan, iqamath, reminder }

(String, DateTime) entryForSlot(PrayerSlot slot, PrayerTimesComputed t) {
  return switch (slot) {
    PrayerSlot.fajr => ('Fajr', t.fajr),
    PrayerSlot.dhuhr => ('Dhuhr', t.dhuhr),
    PrayerSlot.asr => ('Asr', t.asr),
    PrayerSlot.maghrib => ('Maghrib', t.maghrib),
    PrayerSlot.isha => ('Isha', t.isha),
  };
}

/// Adhan/iqamath ids are unchanged from before the reminder feature
/// existed (slot.index * 2 + 0/1) so upgrading installs don't leave an
/// orphaned alarm under a since-renumbered id — the reminder slot gets
/// its own non-overlapping range instead of reshuffling those.
int idForSlot(PrayerSlot slot, {NotificationKind kind = NotificationKind.adhan}) {
  return switch (kind) {
    NotificationKind.adhan => slot.index * 2,
    NotificationKind.iqamath => slot.index * 2 + 1,
    NotificationKind.reminder => 100 + slot.index,
  };
}

String formatClockTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
