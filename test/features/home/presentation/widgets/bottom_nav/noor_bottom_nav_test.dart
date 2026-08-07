// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Confirms the renamed tab labels (Section 2 of the UI Structure Pass:
// Home | Prayer Times | Al Quran | Duas & Dhikr | More) render, and
// that tapping a tab reports the tapped index back to the caller.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/home/presentation/widgets/bottom_nav/noor_bottom_nav.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('shows all five renamed tab labels and reports taps', (tester) async {
    var tapped = -1;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          bottomNavigationBar: NoorBottomNav(
            selectedIndex: 0,
            onTap: (i) => tapped = i,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Prayer Times'), findsOneWidget);
    expect(find.text('Al Quran'), findsOneWidget);
    expect(find.text('Duas & Dhikr'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    await tester.tap(find.text('Al Quran'));
    await tester.pump();
    expect(tapped, 2);
  });
}
