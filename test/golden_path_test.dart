// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Golden path without a device: on a fresh day, tick a prayer that has
// already started and see it reflected on the Progress card; a prayer
// that has not started yet cannot be ticked.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import 'package:noor/features/prayer_tracker/presentation/progress/progress_card.dart';
import 'package:noor/features/prayer_tracker/presentation/widgets/prayer_tracker_card.dart';

import 'helpers/silent_haptics.dart';
import 'helpers/theme_harness.dart';

class _OneDayRepository extends PrayerTrackerRepository {
  final Set<String> done = {};

  @override
  Future<Set<String>> completedPrayersOn(DateTime date) async => {...done};

  @override
  Future<bool> isFastingDay(DateTime date) async => false;

  @override
  Future<int> currentPrayerStreak(DateTime date) async => 0;

  @override
  Future<int> currentFastingStreak(DateTime date) async => 0;

  @override
  Future<void> setPrayerCompleted(DateTime date, String prayer, {required bool completed}) async {
    completed ? done.add(prayer) : done.remove(prayer);
  }

  @override
  Future<Map<DateTime, int>> completionCountsByDay() async {
    final now = DateTime.now();
    return done.isEmpty ? {} : {DateTime(now.year, now.month, now.day): done.length};
  }
}

void main() {
  testWidgets('tick a started prayer, not a future one, then see it on Progress', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 1400 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final repo = _OneDayRepository();
    final cubit = PrayerTrackerCubit(repository: repo, hapticService: SilentHaptics());
    await cubit.load();

    final now = DateTime.now();
    final times = PrayerTimesComputed(
      fajr: now.subtract(const Duration(hours: 6)),
      sunrise: now.subtract(const Duration(hours: 5)),
      dhuhr: now.add(const Duration(hours: 2)),
      asr: now.add(const Duration(hours: 5)),
      maghrib: now.add(const Duration(hours: 8)),
      isha: now.add(const Duration(hours: 9)),
    );

    await tester.pumpWidget(
      themedApp(
        Scaffold(
          body: SingleChildScrollView(
            child: BlocProvider.value(value: cubit, child: PrayerTrackerCard(todayTimes: times)),
          ),
        ),
        allThemes['Emerald Night']!(),
      ),
    );

    await tester.tap(find.text('Dhuhr')); // not started: ignored
    await tester.pumpAndSettle();
    expect(repo.done, isEmpty);

    await tester.tap(find.text('Fajr'));
    await tester.pumpAndSettle();
    expect(repo.done, {'Fajr'});

    await tester.pumpWidget(
      themedApp(
        Scaffold(body: SingleChildScrollView(child: ProgressCard(repository: repo))),
        allThemes['Emerald Night']!(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1/5'), findsOneWidget);
    expect(find.text('20%'), findsOneWidget);
    await cubit.close();
  });
}
