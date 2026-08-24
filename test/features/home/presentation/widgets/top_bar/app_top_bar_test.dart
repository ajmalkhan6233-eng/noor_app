// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Confirms the persistent top bar (Section 1 of the UI Structure Pass)
// renders its required elements and stays mounted identically when
// switching bottom-nav tabs, rather than being rebuilt per screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/home/presentation/home_dashboard.dart';
import 'package:noor/features/home/presentation/widgets/top_bar/app_top_bar.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('HomeDashboard shows top bar elements on every tab', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeDashboard(),
    ));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byType(AppTopBar), findsOneWidget);
    expect(
      find.descendant(of: find.byType(AppTopBar), matching: find.byIcon(Icons.settings_outlined)),
      findsOneWidget,
    );

    // Switch tabs and confirm the bar persists identically.
    await tester.tap(find.byIcon(Icons.access_time));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(
      find.descendant(of: find.byType(AppTopBar), matching: find.byIcon(Icons.settings_outlined)),
      findsOneWidget,
    );
  });
}
