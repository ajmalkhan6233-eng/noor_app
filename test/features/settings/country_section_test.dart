// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// UI-only country picker: Sri Lanka stays selectable/selected by
// default; other countries are shown but disabled with a "Coming
// soon" tag and don't respond to taps.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/settings/presentation/widgets/country_section.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('Sri Lanka is selected by default; others show Coming soon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CountrySection()),
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.countrySriLanka), findsOneWidget);
    expect(find.text(l10n.comingSoonLabel), findsNWidgets(4));

    final radios = tester.widgetList<Icon>(find.byIcon(Icons.radio_button_checked));
    expect(radios.length, 1);
  });

  testWidgets('tapping a disabled country does not select it', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CountrySection()),
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(l10n.countryIndia));
    await tester.pump();

    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(find.text(l10n.countrySriLanka), findsOneWidget);
  });
}
