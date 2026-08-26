// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-08-26 fix: with no location set
// (todayTimes null), every prayer used to be markable regardless of
// whether it had actually happened yet — found live ("now I can
// select all the prayers... not satisfied"). A prayer whose adhan
// hasn't happened must never be toggleable, whether or not today's
// times are known yet.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/home/presentation/widgets/daily_goals_list.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

class _FakeTrackerRepository extends PrayerTrackerRepository {
  final Set<String> completed = {};

  @override
  Future<Set<String>> completedPrayersOn(DateTime date) async => completed;

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
    if (completed) {
      this.completed.add(prayer);
    } else {
      this.completed.remove(prayer);
    }
  }
}

Widget _wrap(PrayerTrackerCubit cubit, {PrayerTimesComputed? todayTimes}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider.value(
        value: cubit,
        child: DailyGoalsList(todayTimes: todayTimes),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'with no location set (todayTimes null), a not-yet-completed prayer '
    'cannot be marked done',
    (tester) async {
      final repo = _FakeTrackerRepository();
      final cubit = PrayerTrackerCubit(repository: repo);
      await cubit.load();

      await tester.pumpWidget(_wrap(cubit));
      await tester.tap(find.text('Dhuhr'));
      await tester.pumpAndSettle();

      expect(cubit.state.completedPrayers.contains('Dhuhr'), isFalse);

      await cubit.close();
    },
  );

  testWidgets(
    'with todayTimes known, a prayer whose time has not yet passed '
    'cannot be marked done',
    (tester) async {
      final repo = _FakeTrackerRepository();
      final cubit = PrayerTrackerCubit(repository: repo);
      await cubit.load();

      final now = DateTime.now();
      final futureTimes = PrayerTimesComputed(
        fajr: now.subtract(const Duration(hours: 6)),
        sunrise: now.subtract(const Duration(hours: 5)),
        dhuhr: now.add(const Duration(hours: 2)),
        asr: now.add(const Duration(hours: 5)),
        maghrib: now.add(const Duration(hours: 8)),
        isha: now.add(const Duration(hours: 9)),
      );

      await tester.pumpWidget(_wrap(cubit, todayTimes: futureTimes));
      await tester.tap(find.text('Dhuhr'));
      await tester.pumpAndSettle();

      expect(cubit.state.completedPrayers.contains('Dhuhr'), isFalse);

      await cubit.close();
    },
  );

  testWidgets(
    'with todayTimes known, a prayer whose time has already passed '
    'can be marked done',
    (tester) async {
      final repo = _FakeTrackerRepository();
      final cubit = PrayerTrackerCubit(repository: repo);
      await cubit.load();

      final now = DateTime.now();
      final pastTimes = PrayerTimesComputed(
        fajr: now.subtract(const Duration(hours: 6)),
        sunrise: now.subtract(const Duration(hours: 5)),
        dhuhr: now.subtract(const Duration(hours: 2)),
        asr: now.add(const Duration(hours: 3)),
        maghrib: now.add(const Duration(hours: 6)),
        isha: now.add(const Duration(hours: 7)),
      );

      await tester.pumpWidget(_wrap(cubit, todayTimes: pastTimes));
      await tester.tap(find.text('Dhuhr'));
      await tester.pumpAndSettle();

      expect(cubit.state.completedPrayers.contains('Dhuhr'), isTrue);

      await cubit.close();
    },
  );
}
