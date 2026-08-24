// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';

import 'package:noor/app.dart';
import 'package:noor/core/constants/app_strings.dart';
import 'package:noor/core/constants/splash_config.dart';
import 'package:noor/features/home/presentation/home_dashboard.dart';

void main() {
  testWidgets('NoorApp shows the Bismillah then the home dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NoorApp());

    await tester.pump(SplashConfig.fadeDuration);
    expect(find.text(AppStrings.splashGreeting), findsOneWidget);

    // Advance past hold + fade-out in small steps rather than one big
    // pump or pumpAndSettle — some dashboard tabs show an
    // indeterminate CircularProgressIndicator while loading, which
    // never "settles" on its own.
    const step = Duration(milliseconds: 100);
    var elapsed = Duration.zero;
    final deadline = SplashConfig.holdDuration + SplashConfig.fadeDuration * 2;
    while (elapsed < deadline &&
        find.byType(HomeDashboard).evaluate().isEmpty) {
      await tester.pump(step);
      elapsed += step;
    }

    expect(find.byType(HomeDashboard), findsOneWidget);

    // The debug build stamp used to live on Home and was asserted
    // here — moved to the About screen (2026-08-24 live-device
    // review: a raw "Build dev · #0" line on the screen every real
    // user opens first read as leaked debug UI). See
    // test/features/settings/presentation/about_screen_test.dart for
    // its coverage now.
  });
}
