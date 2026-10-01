// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The prayer-time widgets render in all four themes at 100% and 200%
// text without overflow, and the time rows use the same style on Home
// (strip) and Prayer Times (list).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/app_typography.dart';
import 'package:noor/features/home/presentation/widgets/prayer_times_strip.dart';
import 'package:noor/features/prayer_times/data/iqamath_offsets.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_times/logic/adhan_preview_cubit.dart';
import 'package:noor/features/prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import 'package:noor/features/prayer_times/presentation/widgets/prayer_countdown_row.dart';
import 'package:noor/features/prayer_times/presentation/widgets/prayer_hero.dart';
import 'package:noor/features/prayer_times/presentation/widgets/prayer_times_list.dart';

import '../../helpers/theme_harness.dart';

PrayerTimesComputed _times() {
  final now = DateTime.now();
  return PrayerTimesComputed(
    fajr: now.subtract(const Duration(hours: 6)),
    sunrise: now.subtract(const Duration(hours: 5)),
    dhuhr: now.add(const Duration(hours: 2)),
    asr: now.add(const Duration(hours: 5)),
    maghrib: now.add(const Duration(hours: 8)),
    isha: now.add(const Duration(hours: 9)),
  );
}

void main() {
  final widgets = <String, Widget Function()>{
    'Prayer hero': () => PrayerHero(times: _times(), offsets: const IqamathOffsetMinutes()),
    'Prayer times list': () => PrayerTimesList(times: _times(), iqamathOffsets: const IqamathOffsetMinutes()),
    'Prayer times strip': () => PrayerTimesStrip(times: _times()),
    'Countdown row': () => PrayerCountdownRow(
      prayerName: 'Dhuhr',
      remaining: const Duration(hours: 1, minutes: 59, seconds: 3),
      now: DateTime(2026, 10, 1, 10, 5),
    ),
  };

  for (final theme in allThemes.entries) {
    for (final entry in widgets.entries) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('${entry.key}, ${theme.key}, ${(scale * 100).round()}% text', (tester) async {
          tester.view.physicalSize = const Size(360 * 3, 740 * 3);
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            themedApp(
              MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => AdhanPreviewCubit()),
                  BlocProvider(create: (_) => PrayerCubit()),
                ],
                child: Scaffold(body: SingleChildScrollView(child: entry.value())),
              ),
              theme.value(),
              textScale: scale,
            ),
          );
          await tester.pump(const Duration(seconds: 1));

          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('time text uses the same style on Home (strip) and Prayer Times (list)', (tester) async {
    await tester.pumpWidget(
      themedApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AdhanPreviewCubit()),
            BlocProvider(create: (_) => PrayerCubit()),
          ],
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  PrayerTimesStrip(times: _times()),
                  PrayerTimesList(times: _times()),
                ],
              ),
            ),
          ),
        ),
        allThemes['Nebula']!(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    final timeTexts = tester
        .widgetList<Text>(find.byType(Text))
        .where((t) => RegExp(r'^\d{1,2}:\d{2}').hasMatch(t.data ?? ''))
        .toList();
    expect(timeTexts, isNotEmpty);
    for (final t in timeTexts) {
      expect(t.style?.fontSize, AppTypography.timeSmallSize, reason: t.data);
      expect(t.style?.fontWeight, FontWeight.w600, reason: t.data);
    }
  });
}
