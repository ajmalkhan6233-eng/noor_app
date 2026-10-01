// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The name comes alive: Home greeting, Settings editor, and the live
// ring on the tracker card that celebrates the fifth tick.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/home/presentation/widgets/hero_card.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import 'package:noor/features/prayer_tracker/presentation/widgets/prayer_tracker_card.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';
import 'package:noor/features/settings/logic/settings_cubit/settings_cubit.dart';
import 'package:noor/features/settings/presentation/widgets/profile_name_section.dart';

import '../helpers/silent_haptics.dart';
import '../helpers/theme_harness.dart';

class _Settings extends SettingsRepository {
  AppSettings current = const AppSettings();
  @override
  Future<AppSettings> load() async => current;
  @override
  Future<void> save(AppSettings settings) async => current = settings;
}

class _Tracker extends PrayerTrackerRepository {
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
  Future<void> setPrayerCompleted(DateTime date, String prayer, {required bool completed}) async =>
      completed ? done.add(prayer) : done.remove(prayer);
}

void main() {
  testWidgets('Home greets by name, and not without one', (tester) async {
    await tester.pumpWidget(
      themedApp(const Scaffold(body: HeroCard(hijriOffsetDays: 0, profileName: ' Ajmal ')), allThemes['Dawn']!()),
    );
    expect(find.text('Assalamu Alaikum, Ajmal'), findsOneWidget);

    await tester.pumpWidget(
      themedApp(const Scaffold(body: HeroCard(hijriOffsetDays: 0)), allThemes['Dawn']!()),
    );
    expect(find.textContaining('Assalamu Alaikum'), findsNothing);
  });

  group('Settings name editor', () {
    Future<_Settings> pump(WidgetTester tester, {String? name}) async {
      final repo = _Settings()..current = AppSettings(profileName: name);
      await tester.pumpWidget(
        themedApp(
          BlocProvider(
            create: (_) => SettingsCubit(repository: repo)..load(),
            child: const Scaffold(body: ProfileNameSection()),
          ),
          allThemes['Nebula']!(),
        ),
      );
      await tester.pump();
      await tester.pump();
      return repo;
    }

    testWidgets('add, change and remove the name', (tester) async {
      final repo = await pump(tester);
      expect(find.text('Add your name'), findsOneWidget);

      await tester.tap(find.text('Add your name'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Ajmal');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repo.current.profileName, 'Ajmal');
      expect(find.text('Ajmal'), findsOneWidget);

      await tester.tap(find.text('Ajmal'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Aj');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repo.current.profileName, 'Aj');

      await tester.tap(find.text('Aj'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove name'));
      await tester.pumpAndSettle();
      expect(repo.current.profileName, '');
      expect(find.text('Add your name'), findsOneWidget);
    });

    testWidgets('cancel keeps the name', (tester) async {
      final repo = await pump(tester, name: 'Ajmal');
      await tester.tap(find.text('Ajmal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repo.current.profileName, 'Ajmal');
    });
  });

  testWidgets('tracker card ring follows the ticks and celebrates the fifth', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 1400 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final repo = _Tracker();
    final cubit = PrayerTrackerCubit(repository: repo, hapticService: SilentHaptics());
    await cubit.load();
    final now = DateTime.now();
    final times = PrayerTimesComputed(
      fajr: now.subtract(const Duration(hours: 10)),
      sunrise: now.subtract(const Duration(hours: 9)),
      dhuhr: now.subtract(const Duration(hours: 8)),
      asr: now.subtract(const Duration(hours: 6)),
      maghrib: now.subtract(const Duration(hours: 4)),
      isha: now.subtract(const Duration(hours: 2)),
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
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('0/5'), findsOneWidget);

    for (final prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib']) {
      await tester.tap(find.text(prayer));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.text('4/5'), findsOneWidget);
    expect(find.byKey(const Key('progress-celebration')), findsNothing);

    await tester.tap(find.text('Isha'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('5/5'), findsOneWidget);
    expect(find.byKey(const Key('progress-celebration')), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('progress-celebration')), findsNothing);
    await cubit.close();
  });
}
