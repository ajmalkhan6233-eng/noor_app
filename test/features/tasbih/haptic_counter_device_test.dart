// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/tasbih/presentation/widgets/haptic_counter_device.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('shows the count and calls onTap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      _wrap(HapticCounterDevice(count: 5, onTap: () => tapped++)),
    );

    expect(find.text('5'), findsOneWidget);

    await tester.tap(find.byType(HapticCounterDevice));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(tapped, 1);
  });

  testWidgets('does not crash when pulsing turns on (milestone burst)', (tester) async {
    await tester.pumpWidget(
      _wrap(HapticCounterDevice(count: 33, onTap: () {})),
    );

    await tester.pumpWidget(
      _wrap(HapticCounterDevice(count: 33, onTap: () {}, pulsing: true)),
    );
    await tester.pump();

    expect(find.text('33'), findsOneWidget);
  });
}
