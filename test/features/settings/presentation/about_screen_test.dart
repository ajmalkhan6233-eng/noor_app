// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The debug build stamp moved here from Home (2026-08-24 live-device
// review) — still needed to confirm which commit an installed APK
// actually contains, just no longer shown to every user on the
// screen they open first. flutter_test runs in debug mode, so this
// assertion still holds. Never remove this coverage entirely.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/build_info.dart';
import 'package:noor/features/settings/presentation/about_screen.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('AboutScreen shows the debug build stamp', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AboutScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text(BuildInfo.label), findsOneWidget);
  });
}
