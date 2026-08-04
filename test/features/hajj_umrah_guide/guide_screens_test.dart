// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Both guide screens must always show the persistent
// scholar-confirmation notice, regardless of scroll position or
// whether the live-sourced Talbiyah/Rabbana text has resolved yet.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/hajj_umrah_guide/presentation/hajj_guide_screen.dart';
import 'package:noor/features/hajj_umrah_guide/presentation/umrah_guide_screen.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets('Umrah guide shows the persistent scholar-confirmation notice', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const UmrahGuideScreen()));
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.scholarConfirmationNotice), findsOneWidget);
  });

  testWidgets('Hajj guide shows the persistent scholar-confirmation notice', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const HajjGuideScreen()));
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.scholarConfirmationNotice), findsOneWidget);
  });
}
