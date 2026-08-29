// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/presentation/widgets/progress_hero_stat.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('computes completion percentage and perfect-day count', (tester) async {
    final days = [
      (date: DateTime(2026, 3, 1), completedCount: 5, fasted: false),
      (date: DateTime(2026, 3, 2), completedCount: 5, fasted: false),
      (date: DateTime(2026, 3, 3), completedCount: 0, fasted: false),
      (date: DateTime(2026, 3, 4), completedCount: 5, fasted: false),
    ];
    // 15 of 20 possible = 75%, 3 perfect days.
    await tester.pumpWidget(_wrap(ProgressHeroStat(days: days)));

    expect(find.text('75%'), findsOneWidget);
    expect(find.text('3 perfect days'), findsOneWidget);
  });

  testWidgets('handles an empty range without dividing by zero', (tester) async {
    await tester.pumpWidget(_wrap(const ProgressHeroStat(days: [])));

    expect(find.text('0%'), findsOneWidget);
    expect(find.text('0 perfect days'), findsOneWidget);
  });

  testWidgets('singular wording for exactly one perfect day', (tester) async {
    final days = [(date: DateTime(2026, 3, 1), completedCount: 5, fasted: false)];
    await tester.pumpWidget(_wrap(ProgressHeroStat(days: days)));

    expect(find.text('1 perfect day'), findsOneWidget);
  });
}
