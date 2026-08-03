// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:noor/app.dart';
import 'package:noor/core/constants/app_strings.dart';

void main() {
  testWidgets('NoorApp shows splash greeting on launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NoorApp());

    expect(find.text(AppStrings.splashGreeting), findsOneWidget);

    // Let the splash screen's delayed fade-out timer fire so no timer is
    // left pending when the test tears down the widget tree.
    await tester.pumpAndSettle(const Duration(milliseconds: 2500));
  });
}
