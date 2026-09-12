// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test: PrayerTrackerCubit is created once at app startup
// and shared across Home and Prayer Times for the app's whole
// lifetime (2026-09-06). Before this fix, "today" was captured once
// as an absolute DateTime in PrayerTrackerState.viewedDate at
// construction time — a session left open across midnight (e.g.
// marking Isha done a few minutes after 12:00am) would still write
// the completion against yesterday's date key. Fixed by storing a
// daysBack offset and re-resolving "today" from the clock on every
// access instead of freezing it.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import 'package:noor/features/prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_state.dart';

class _FakeTrackerRepository extends PrayerTrackerRepository {
  final Map<String, Set<String>> completedByDate = {};

  String _key(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<Set<String>> completedPrayersOn(DateTime date) async => completedByDate[_key(date)] ?? {};

  @override
  Future<bool> isFastingDay(DateTime date) async => false;

  @override
  Future<int> currentPrayerStreak(DateTime date) async => 0;

  @override
  Future<int> currentFastingStreak(DateTime date) async => 0;

  @override
  Future<void> setPrayerCompleted(
    DateTime date,
    String prayer, {
    required bool completed,
  }) async {
    final key = _key(date);
    final set = completedByDate.putIfAbsent(key, () => {});
    if (completed) {
      set.add(prayer);
    } else {
      set.remove(prayer);
    }
  }
}

void main() {
  test(
    'a prayer marked done just after midnight is logged against the new '
    'day, not the day the cubit was created on',
    () async {
      final realNow = PrayerTrackerState.debugNowOverride;
      addTearDown(() => PrayerTrackerState.debugNowOverride = realNow);

      final justBeforeMidnight = DateTime(2026, 9, 12, 23, 59);
      PrayerTrackerState.debugNowOverride = () => justBeforeMidnight;

      final repo = _FakeTrackerRepository();
      final cubit = PrayerTrackerCubit(repository: repo);
      await cubit.load();
      expect(cubit.state.isViewingToday, isTrue);

      // The session stays open across midnight without ever being
      // recreated — exactly how the shared Home/Prayer Times cubit
      // behaves in production.
      final justAfterMidnight = DateTime(2026, 9, 13, 0, 3);
      PrayerTrackerState.debugNowOverride = () => justAfterMidnight;

      await cubit.togglePrayer('Isha');

      expect(repo.completedByDate['2026-09-13'], {'Isha'});
      expect(repo.completedByDate['2026-09-12'], isNull);
      expect(cubit.state.isViewingToday, isTrue);

      await cubit.close();
    },
  );
}
