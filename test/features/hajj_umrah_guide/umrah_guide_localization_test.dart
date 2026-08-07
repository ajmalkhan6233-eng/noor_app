// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Confirms the fix for a real bug: previously only the Umrah guide's
// AppBar title responded to the language setting, while the 8 step
// cards stayed English regardless of locale. Step titles are short
// structural labels only (translated); step bodies are Hajj/Umrah
// rite description text and stay English-only per CLAUDE.md rule 7 —
// GuideStepCard must show a plain note about that in non-English
// locales instead of silently looking half-translated.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/hajj_umrah_guide/presentation/umrah_guide_screen.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child, Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets('Tamil locale translates step titles and shows the English-only note', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const UmrahGuideScreen(), const Locale('ta')));
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('ta'));
    expect(find.text(l10n.umrahStep1Title), findsOneWidget);
    expect(find.text(l10n.guideBodyEnglishOnlyNote), findsWidgets);
  });

  testWidgets('English locale shows English titles and no English-only note', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const UmrahGuideScreen(), const Locale('en')));
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.umrahStep1Title), findsOneWidget);
    expect(find.text(l10n.guideBodyEnglishOnlyNote), findsNothing);
  });
}
