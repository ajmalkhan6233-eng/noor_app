// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Smoke test: the orb builds, shows the count, responds to tap, and
// a drag-then-release doesn't crash (spring simulation runs to
// completion cleanly).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/tasbih/presentation/widgets/tasbih_orb.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('shows the count and calls onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(TasbihOrb(count: 5, onTap: () => tapped = true)),
    );
    await tester.pumpAndSettle();

    expect(find.text('5'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('dragging and releasing springs back without crashing', (tester) async {
    await tester.pumpWidget(_wrap(TasbihOrb(count: 33, pulsing: true, onTap: () {})));
    await tester.pumpAndSettle();

    await tester.drag(find.text('33'), const Offset(20, 15));
    await tester.pump();
    // Let the spring-back and milestone shake animations run to completion.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('33'), findsOneWidget);
  });
}
