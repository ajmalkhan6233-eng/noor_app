// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/presentation/widgets/azkar_header.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('shows the given title', (tester) async {
    await tester.pumpWidget(_wrap(const AzkarHeader(title: 'Azkar')));

    expect(find.text('Azkar'), findsOneWidget);
  });

  testWidgets('does not crash as the ambient glow animates', (tester) async {
    await tester.pumpWidget(_wrap(const AzkarHeader(title: 'Azkar')));

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Azkar'), findsOneWidget);
  });
}
