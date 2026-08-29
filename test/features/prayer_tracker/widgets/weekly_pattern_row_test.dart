// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/presentation/widgets/weekly_pattern_row.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('shows a checkmark for a perfect day and a count for a partial day', (tester) async {
    final days = [
      (date: DateTime.now(), completedCount: 5, fasted: false),
      (date: DateTime.now().subtract(const Duration(days: 1)), completedCount: 3, fasted: false),
      (date: DateTime.now().subtract(const Duration(days: 2)), completedCount: 0, fasted: false),
    ];
    await tester.pumpWidget(_wrap(WeeklyPatternRow(days: days)));

    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('shows a fasting glyph only on fasted days', (tester) async {
    final days = [
      (date: DateTime.now(), completedCount: 5, fasted: true),
      (date: DateTime.now().subtract(const Duration(days: 1)), completedCount: 5, fasted: false),
    ];
    await tester.pumpWidget(_wrap(WeeklyPatternRow(days: days)));

    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
  });
}
