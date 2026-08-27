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

import 'package:flutter_test/flutter_test.dart';

import 'package:noor/app.dart';
import 'package:noor/core/constants/splash_config.dart';
import 'package:noor/features/home/presentation/home_dashboard.dart';
import 'package:noor/features/home/presentation/widgets/hero_card.dart';
import 'package:noor/features/home/presentation/widgets/streak_capsule.dart';
import 'package:noor/features/home/presentation/widgets/bottom_nav/noor_bottom_nav.dart';
import 'package:noor/features/more/presentation/more_screen.dart';
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
  testWidgets('Home tab renders HeroCard without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(HeroCard), findsOneWidget);
    // Streak tracker is cut from v1 (CLAUDE.md Deferred, 2026-08-23) —
    // confirm it's genuinely gone from Home, not just untested.
    expect(find.byType(StreakCapsule), findsNothing);
  });

  testWidgets('Prayer Times tab opens from the bottom nav without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);

    // The bottom nav's icons are this app's own original line-art
    // (NoorIcon/CustomPainter, 2026-08-27), not Material IconData, so
    // find.byIcon no longer applies — the tab's visible label is a
    // stable, user-facing way to find it instead. Home's own Quick
    // Actions row repeats the same labels and stays alive in the tree
    // (tabs aren't disposed on switch), so scope to the bottom nav.
    await tester.tap(
      find.descendant(of: find.byType(NoorBottomNav), matching: find.text('Prayer Times')),
    );
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(PrayerTimesScreen), findsOneWidget);
  });

  testWidgets('Tasbih screen opens from More without throwing', (tester) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);

    await tester.tap(
      find.descendant(of: find.byType(NoorBottomNav), matching: find.text('More')),
    );
    await _settle(tester);
    // Home's own QuickActionRow shortcut uses the same label as
    // More's row and stays alive in the tree (tabs aren't disposed on
    // switch), so find.text('Tasbih') alone can match more than one —
    // scope to MoreScreen.
    await tester.tap(
      find.descendant(of: find.byType(MoreScreen), matching: find.text('Tasbih')),
    );
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(TasbihScreen), findsOneWidget);
  });

  testWidgets('Calendar screen opens from More without throwing', (tester) async {
    await tester.pumpWidget(const NoorApp());
    await _pumpPastSplash(tester);

    await tester.tap(
      find.descendant(of: find.byType(NoorBottomNav), matching: find.text('More')),
    );
    await _settle(tester);
    await tester.tap(
      find.descendant(of: find.byType(MoreScreen), matching: find.text('Calendar')),
    );
    await _settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(CalendarScreen), findsOneWidget);
  });
}
