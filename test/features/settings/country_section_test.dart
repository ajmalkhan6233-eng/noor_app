// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sri Lanka is the only country with working district/holiday data.
// Used to list India/Malaysia/UK/US alongside it as disabled "Coming
// soon" rows; removed (2026-08-24 live-device review) as non-
// functional clutter — this now just states the working country.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/settings/presentation/widgets/country_section.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('CountrySection shows Sri Lanka only', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CountrySection()),
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.countrySriLanka), findsOneWidget);
    expect(find.text(l10n.countryIndia), findsNothing);
    expect(find.text(l10n.comingSoonLabel), findsNothing);
  });
}
