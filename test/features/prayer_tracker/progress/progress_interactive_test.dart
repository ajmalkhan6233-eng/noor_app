// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The interactive Progress card: animated ring + celebration, tappable
// ring and bars, streak flame and milestones, weekly goal, badges, and
// the Week/Month switch with the tappable heatmap.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/presentation/progress/progress_card.dart';
import 'package:noor/features/prayer_tracker/presentation/progress/progress_heatmap.dart';
import 'package:noor/features/prayer_tracker/presentation/progress/progress_ring.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/theme_harness.dart';

DateTime _day(int back) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day - back);
}

class _Repo extends PrayerTrackerRepository {
  _Repo(this.counts, {this.prayers = const {'Fajr', 'Dhuhr'}});
  final Map<DateTime, int> counts;
  final Set<String> prayers;

  @override
  Future<Map<DateTime, int>> completionCountsByDay() async => counts;

  @override
  Future<Set<String>> completedPrayersOn(DateTime date) async => prayers;
}

Map<DateTime, int> _streak(int days, {int todayDone = 5}) => {
  for (var i = 0; i < days; i++) _day(i): i == 0 ? todayDone : 5,
};

Future<void> _pumpCard(
  WidgetTester tester,
  Map<DateTime, int> counts, {
  String theme = 'Nebula',
  double scale = 1.0,
  Set<String> prayers = const {'Fajr', 'Dhuhr'},
}) async {
  tester.view.physicalSize = const Size(360 * 3, 2400 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    themedApp(
      Scaffold(
        body: SingleChildScrollView(child: ProgressCard(repository: _Repo(counts, prayers: prayers))),
      ),
      allThemes[theme]!(),
      textScale: scale,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

double _fraction(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.descendant(of: find.byType(ProgressRing), matching: find.byType(CustomPaint)).first,
  );
  // ignore: avoid_dynamic_calls
  return (paint.painter as dynamic).fraction as double;
}

/// Not pumpAndSettle: the streak flame animates forever.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('ring', () {
    testWidgets('fills smoothly from empty to the day total', (tester) async {
      await tester.pumpWidget(themedApp(const Scaffold(body: Center(child: ProgressRing(done: 3))), allThemes['Dawn']!()));
      expect(_fraction(tester), 0, reason: 'starts empty');
      await tester.pump(const Duration(milliseconds: 250));
      final mid = _fraction(tester);
      expect(mid, inExclusiveRange(0, 0.6));
      await tester.pump(const Duration(milliseconds: 800));
      expect(_fraction(tester), closeTo(0.6, 1e-6));
    });

    testWidgets('reaching 5/5 celebrates once, then settles', (tester) async {
      Widget ring(int done) => themedApp(Scaffold(body: Center(child: ProgressRing(key: const Key('r'), done: done))), allThemes['Nebula']!());
      await tester.pumpWidget(ring(4));
      await _settle(tester);
      expect(find.byKey(const Key('progress-celebration')), findsNothing);

      await tester.pumpWidget(ring(5));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(const Key('progress-celebration')), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.byKey(const Key('progress-celebration')), findsNothing);
    });

    testWidgets('no celebration when the screen opens already at 5/5', (tester) async {
      await tester.pumpWidget(themedApp(const Scaffold(body: Center(child: ProgressRing(done: 5))), allThemes['Nebula']!()));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(const Key('progress-celebration')), findsNothing);
    });

    testWidgets('reduced motion: instant fill and no celebration', (tester) async {
      Widget ring(int done) => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: themedApp(Scaffold(body: Center(child: ProgressRing(done: done))), allThemes['Nebula']!()),
      );
      await tester.pumpWidget(ring(4));
      await tester.pumpWidget(ring(5));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const Key('progress-celebration')), findsNothing);
    });
  });

  group('day details', () {
    testWidgets('tapping the ring opens today with the ticked prayers', (tester) async {
      await _pumpCard(tester, {_day(0): 2});
      await tester.tap(find.bySemanticsLabel('2 of 5 prayers done today'));
      await _settle(tester);

      expect(find.text('2 of 5 prayers'), findsOneWidget);
      for (final p in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
        expect(find.text(p), findsOneWidget);
      }
      expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
      expect(find.textContaining('Prayers can be ticked on Home'), findsOneWidget);
    });

    testWidgets('tapping a day bar opens that day', (tester) async {
      await _pumpCard(tester, {_day(1): 4, _day(0): 2}, prayers: {'Fajr', 'Dhuhr', 'Asr', 'Maghrib'});
      await tester.tap(find.bySemanticsLabel(RegExp(r': 4 of 5 prayers$')));
      await _settle(tester);

      expect(find.text('4 of 5 prayers'), findsOneWidget);
    });
  });

  group('streak, milestones and badges', () {
    testWidgets('a 3-day streak shows the 3-day message and the first badge', (tester) async {
      await _pumpCard(tester, _streak(3));
      expect(find.text('3 days in a row. A good start, keep going.'), findsOneWidget);
      expect(find.bySemanticsLabel('3 day streak badge, earned'), findsOneWidget);
      expect(find.bySemanticsLabel('7 day streak badge, not earned yet'), findsOneWidget);
      expect(find.text('Next badge at 7 days'), findsOneWidget);
    });

    testWidgets('a 4-day streak has no milestone message', (tester) async {
      await _pumpCard(tester, _streak(4));
      expect(find.textContaining('A good start, keep going'), findsNothing);
      expect(find.textContaining('whole week'), findsNothing);
    });

    testWidgets('7-day streak: week message and two badges', (tester) async {
      await _pumpCard(tester, _streak(7));
      expect(find.text('A whole week with all five prayers. Well done.'), findsOneWidget);
      expect(find.bySemanticsLabel('7 day streak badge, earned'), findsOneWidget);
      expect(find.bySemanticsLabel('30 day streak badge, not earned yet'), findsOneWidget);
    });

    testWidgets('the flame announces the current streak', (tester) async {
      await _pumpCard(tester, _streak(5));
      expect(find.bySemanticsLabel('Current streak 5 days'), findsOneWidget);
    });
  });

  group('weekly goal', () {
    testWidgets('shows progress toward the default 30 and can be changed and kept', (tester) async {
      await _pumpCard(tester, _streak(5));
      expect(find.text('25 of 30 prayers this week'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Change weekly goal'));
      await _settle(tester);
      await tester.tap(find.bySemanticsLabel('Lower the goal'));
      await tester.pump();
      expect(find.text('29 prayers a week'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await _settle(tester);
      expect(find.text('25 of 29 prayers this week'), findsOneWidget);

      // A new card (a later visit) reads the stored goal.
      await _pumpCard(tester, _streak(5));
      expect(find.text('25 of 29 prayers this week'), findsOneWidget);
    });

    testWidgets('reaching the goal says so', (tester) async {
      SharedPreferences.setMockInitialValues({'progress_weekly_goal': 20});
      await _pumpCard(tester, _streak(5));
      expect(find.text('Goal reached. Well done.'), findsWidgets);
    });
  });

  group('week / month', () {
    testWidgets('Month shows the heatmap; arrows move months, never past this one; a day opens details', (tester) async {
      await _pumpCard(tester, {_day(0): 3});
      expect(find.byType(ProgressHeatmap), findsNothing);

      await tester.tap(find.bySemanticsLabel('Month'));
      await tester.pump();
      expect(find.byType(ProgressHeatmap), findsOneWidget);

      final heat = tester.widget<ProgressHeatmap>(find.byType(ProgressHeatmap));
      final thisMonth = heat.month;
      expect(heat.canGoNext, isFalse, reason: 'already the current month');

      await tester.tap(find.bySemanticsLabel('Previous month'));
      await tester.pump();
      final previous = tester.widget<ProgressHeatmap>(find.byType(ProgressHeatmap));
      expect(previous.month, DateTime(thisMonth.year, thisMonth.month - 1));
      expect(previous.canGoNext, isTrue);

      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pump();
      expect(tester.widget<ProgressHeatmap>(find.byType(ProgressHeatmap)).month, thisMonth);

      await tester.tap(find.bySemanticsLabel(RegExp(r': 3 of 5 prayers$')).last);
      await _settle(tester);
      expect(find.textContaining('of 5 prayers'), findsWidgets);
      expect(find.text('Fajr'), findsOneWidget);
    });

    testWidgets('switching back to Week brings the bars back', (tester) async {
      await _pumpCard(tester, {_day(0): 1});
      await tester.tap(find.bySemanticsLabel('Month'));
      await tester.pump();
      await tester.tap(find.bySemanticsLabel('Week'));
      await tester.pump();
      expect(find.byType(ProgressHeatmap), findsNothing);
    });
  });

  for (final theme in allThemes.keys) {
    for (final scale in [1.0, 2.0]) {
      for (final month in [false, true]) {
        testWidgets('card in $theme at ${(scale * 100).round()}% text, ${month ? 'month' : 'week'} view', (tester) async {
          await _pumpCard(tester, _streak(7), theme: theme, scale: scale);
          if (month) {
            await tester.tap(find.bySemanticsLabel('Month'));
            await tester.pump();
          }
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
