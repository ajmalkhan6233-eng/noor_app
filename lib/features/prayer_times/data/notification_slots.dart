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

/// Just the display name, for callers (like the "test adhan" button)
/// that have no actual [PrayerTimesComputed] to hand [entryForSlot].
String slotLabel(PrayerSlot slot) => switch (slot) {
  PrayerSlot.fajr => 'Fajr',
  PrayerSlot.dhuhr => 'Dhuhr',
  PrayerSlot.asr => 'Asr',
  PrayerSlot.maghrib => 'Maghrib',
  PrayerSlot.isha => 'Isha',
};

/// How many days ahead notifications are scheduled every time the app
/// (re)computes prayer times — the fix for a real gap (2026-08-26):
/// nothing ever scheduled more than "today", so on any day the app
/// wasn't opened, that day's prayers simply had no notification at
/// all. This is what actually explained "worked once, then never came
/// again" — not a reboot-wipe (the plugin's own boot receiver already
/// handles that correctly), but a missing scheduling horizon.
const int notificationSchedulingHorizonDays = 7;

/// Adhan/iqamath ids are unchanged from before the reminder feature
/// existed (slot.index * 2 + 0/1) so upgrading installs don't leave an
/// orphaned alarm under a since-renumbered id — the reminder slot gets
/// its own non-overlapping range instead of reshuffling those.
/// [dayOffset] (0 = today) is spaced by 1000 — comfortably clear of
/// every other id range used (reminder tops out at 104, test-adhan
/// starts at 9000) even at the maximum horizon above.
int idForSlot(
  PrayerSlot slot, {
  NotificationKind kind = NotificationKind.adhan,
  int dayOffset = 0,
}) {
  final base = switch (kind) {
    NotificationKind.adhan => slot.index * 2,
    NotificationKind.iqamath => slot.index * 2 + 1,
    NotificationKind.reminder => 100 + slot.index,
  };
  return base + dayOffset * 1000;
}

String formatClockTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
