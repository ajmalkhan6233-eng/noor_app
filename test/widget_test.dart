// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';

import 'package:noor/app.dart';
import 'package:noor/core/constants/splash_config.dart';
import 'package:noor/features/home/presentation/home_dashboard.dart';

void main() {
  testWidgets('NoorApp shows the cosmic greeting then the home dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NoorApp());

    // Advance enough for the first greeting word to fully appear. Use
    // fixed pumps rather than pumpAndSettle — the starfield/rotation
    // Ticker animates continuously and never "settles" on its own.
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('BISMILLAHIR'), findsOneWidget);

    // Advance past the full splash sequence; onFinished should swap
    // the splash out for the main dashboard.
    await tester.pump(
      SplashConfig.totalDuration + const Duration(milliseconds: 100),
    );
    await tester.pump();

    expect(find.byType(HomeDashboard), findsOneWidget);
  });
}
