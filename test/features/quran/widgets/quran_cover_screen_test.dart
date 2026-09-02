// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/presentation/widgets/quran_cover_screen.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('tapping the cover calls onEnter', (tester) async {
    var entered = false;
    await tester.pumpWidget(_wrap(QuranCoverScreen(onEnter: () => entered = true)));

    await tester.tap(find.byType(QuranCoverScreen));
    expect(entered, isTrue);
  });

  testWidgets('a swipe calls onEnter', (tester) async {
    var entered = false;
    await tester.pumpWidget(_wrap(QuranCoverScreen(onEnter: () => entered = true)));

    await tester.fling(find.byType(QuranCoverScreen), const Offset(0, -300), 800);
    expect(entered, isTrue);
  });

  testWidgets('exposes a single accessible tap target', (tester) async {
    await tester.pumpWidget(_wrap(QuranCoverScreen(onEnter: () {})));

    expect(
      tester.getSemantics(find.byType(QuranCoverScreen)),
      matchesSemantics(isButton: true, hasTapAction: true),
    );
  });
}
