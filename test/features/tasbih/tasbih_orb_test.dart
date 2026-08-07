// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Smoke test: the orb builds, shows the count, responds to tap, and
// a drag-then-release doesn't crash (spring simulation runs to
// completion cleanly). Uses bounded tester.pump() steps rather than
// pumpAndSettle() — the idle breathing/sway animation now repeats
// forever by design, so pumpAndSettle would never return.

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

Future<void> _pumpSteps(WidgetTester tester, Duration total) async {
  const step = Duration(milliseconds: 100);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

void main() {
  testWidgets('shows the count and calls onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(TasbihOrb(count: 5, onTap: () => tapped = true)),
    );
    await _pumpSteps(tester, const Duration(milliseconds: 500));

    expect(find.text('5'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('dragging and releasing springs back without crashing', (tester) async {
    await tester.pumpWidget(_wrap(TasbihOrb(count: 33, pulsing: true, onTap: () {})));
    await _pumpSteps(tester, const Duration(milliseconds: 500));

    await tester.drag(find.text('33'), const Offset(20, 15));
    await tester.pump();
    // Let the spring-back and milestone shake animations run to completion.
    await _pumpSteps(tester, const Duration(seconds: 2));

    expect(find.text('33'), findsOneWidget);
  });
}
