// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression coverage for the 2026-08-26 fix: idForSlot now takes a
// dayOffset so several days can be scheduled at once without one
// day's alarms silently overwriting another's (multiple zonedSchedule
// calls sharing an id just replace the earlier alarm). Collision
// here would mean only the last-scheduled day's notifications
// actually fire.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/notification_slots.dart';

void main() {
  test('every (dayOffset, slot, kind) combination across the full '
      'scheduling horizon produces a unique id', () {
    final ids = <int>{};
    for (var day = 0; day < notificationSchedulingHorizonDays; day++) {
      for (final slot in PrayerSlot.values) {
        for (final kind in NotificationKind.values) {
          final id = idForSlot(slot, kind: kind, dayOffset: day);
          expect(
            ids.add(id),
            isTrue,
            reason: 'duplicate id $id for day $day, $slot, $kind',
          );
        }
      }
    }
  });

  test('dayOffset 0 ids are unchanged from before dayOffset existed', () {
    // Upgrading installs must not end up with an orphaned alarm under
    // a since-renumbered id.
    expect(idForSlot(PrayerSlot.fajr), 0);
    expect(idForSlot(PrayerSlot.fajr, kind: NotificationKind.iqamath), 1);
    expect(idForSlot(PrayerSlot.dhuhr), 2);
    expect(idForSlot(PrayerSlot.isha, kind: NotificationKind.reminder), 104);
  });

  test('ids stay well clear of the 9000+ test-adhan range across the '
      'whole horizon', () {
    for (var day = 0; day < notificationSchedulingHorizonDays; day++) {
      for (final slot in PrayerSlot.values) {
        for (final kind in NotificationKind.values) {
          expect(idForSlot(slot, kind: kind, dayOffset: day), lessThan(9000));
        }
      }
    }
  });
}
