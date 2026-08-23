// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';

import 'package:noor/app.dart';
import 'package:noor/core/constants/app_strings.dart';
import 'package:noor/core/constants/build_info.dart';
import 'package:noor/core/constants/splash_config.dart';
import 'package:noor/features/home/presentation/home_dashboard.dart';

void main() {
  testWidgets('NoorApp shows the greeting then the home dashboard', (
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

    // HomeDashboard mounting doesn't guarantee its first tab's own
    // nested BlocBuilder chain (Settings -> Prayer -> PrayerTracker)
    // has finished its first build yet — each tester.pump() call is
    // one frame, not "wait N ms", so loop a few real frames rather
    // than trusting a single pump(duration) call to cover it.
    for (var i = 0; i < 10 && find.text(BuildInfo.label).evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // The build stamp must always be visible on Home, without digging
    // — it's the only way anyone can confirm which commit an installed
    // APK actually contains. Never remove this coverage.
    expect(find.text(BuildInfo.label), findsOneWidget);
  });
}
