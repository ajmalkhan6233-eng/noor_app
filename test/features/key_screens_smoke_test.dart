// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Widget-level regression coverage for the four key screens named in
// the final pre-release polish pass: Home, Prayer Times, Tasbih,
// Calendar. Not golden/pixel tests — this session has no working
// Flutter install to generate baseline golden images against (see
// CLAUDE.md's noor-build-verify notes on this machine's tooling
// gaps), and committing matchesGoldenFile() calls with no reference
// PNG would just fail CI for an unrelated reason. These are
// structural smoke tests instead: pump the real screen, navigate to
// it the way a user would (same tab/menu taps), and confirm it
// builds without throwing and shows its defining content — cheap to
// run on every change, and enough to catch "this screen now crashes"
// or "this text disappeared" even without a rendered screenshot.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor/app.dart';
import 'package:noor/core/constants/splash_config.dart';
import 'package:noor/features/home/presentation/home_dashboard.dart';
import 'package:noor/features/home/presentation/widgets/hero_card.dart';
import 'package:noor/features/home/presentation/widgets/streak_capsule.dart';
import 'package:noor/features/prayer_times/presentation/prayer_times_screen.dart';
import 'package:noor/features/tasbih/presentation/tasbih_screen.dart';
import 'package:noor/features/calendar/presentation/calendar_screen.dart';

/// Advances in small steps rather than pumpAndSettle — several tabs
/// carry an indeterminate CircularProgressIndicator while their real
/// database load resolves (or, under `flutter test`, never resolves),
/// which never "settles" on its own. Mirrors test/widget_test.dart.
Future<void> _pumpPastSplash(WidgetTester tester) async {
  await tester.pump(SplashConfig.fadeDuration);
  const step = Duration(milliseconds: 100);
  var elapsed = Duration.zero;
  final deadline = SplashConfig.holdDuration + SplashConfig.fadeDuration * 2;
  while (elapsed < deadline && find.byType(HomeDashboard).evaluate().isEmpty) {
    await tester.pump(step);
    elapsed += step;
  }
  expect(find.byType(HomeDashboard), findsOneWidget);
}

/// A handful of real, separate frames — tester.pump(duration) advances
/// the simulated clock but still only processes one frame, so a
/// single large-duration pump doesn't give a nested BlocBuilder chain
/// the several distinct rebuild passes it may need.
Future<void> _settle(WidgetTester tester, {int frames = 8}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('Home tab renders HeroCard and StreakCapsule without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(HeroCard), findsOneWidget);
    expect(find.byType(StreakCapsule), findsOneWidget);
  });

  testWidgets('Prayer Times tab opens from the bottom nav without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);

    await tester.tap(find.byIcon(Icons.access_time));
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(PrayerTimesScreen), findsOneWidget);
  });

  testWidgets('Tasbih screen opens from More without throwing', (tester) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await _settle(tester);
    await tester.tap(find.byIcon(Icons.blur_circular));
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(TasbihScreen), findsOneWidget);
  });

  testWidgets('Calendar screen opens from More without throwing', (tester) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await _settle(tester);
    await tester.tap(find.byIcon(Icons.calendar_month));
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(CalendarScreen), findsOneWidget);
  });
}
