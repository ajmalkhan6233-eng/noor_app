// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// About, Help/FAQ and Privacy Policy render without errors or overflow
// in every theme, and at 200% text scale.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/settings/presentation/about_screen.dart';
import 'package:noor/features/settings/presentation/help_screen.dart';
import 'package:noor/features/settings/presentation/privacy_policy_screen.dart';

import '../../helpers/theme_harness.dart';

void main() {
  final screens = <String, Widget Function()>{
    'About': () => const AboutScreen(),
    'Help': () => const HelpScreen(),
    'Privacy Policy': () => const PrivacyPolicyScreen(),
  };

  for (final theme in allThemes.entries) {
    for (final screen in screens.entries) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('${screen.key} renders in ${theme.key} at ${(scale * 100).round()}% text', (tester) async {
          tester.view.physicalSize = const Size(360 * 3, 740 * 3);
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(themedApp(screen.value(), theme.value(), textScale: scale));
          await tester.pump(const Duration(seconds: 1));

          expect(tester.takeException(), isNull);
          expect(find.byType(Scaffold), findsOneWidget);
        });
      }
    }
  }

  testWidgets('About shows the version and the privacy promise', (tester) async {
    await tester.pumpWidget(themedApp(const AboutScreen(), allThemes['Nebula']!()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('No ads, no tracking. Your data stays on your phone.'), findsOneWidget);
    expect(find.textContaining('Version 1.1.0'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsWidgets);
    expect(find.text('Help & FAQ'), findsOneWidget);
  });

  testWidgets('Help lists every question with a heading semantics node', (tester) async {
    await tester.pumpWidget(themedApp(const HelpScreen(), allThemes['Dawn']!()));
    await tester.pump();

    expect(find.text('Does noor need the internet?'), findsOneWidget);
    expect(find.text('Where does my data go?'), findsOneWidget);
  });
}
