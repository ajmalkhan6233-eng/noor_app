// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression coverage for the 2026-08-26 fix: the native battery-
// optimization exemption channel existed but nothing in the app ever
// called it — this widget is the first (and only) caller.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/settings/presentation/widgets/battery_optimization_section.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const Scaffold(body: BatteryOptimizationSection()),
  );
}

void main() {
  const channel = MethodChannel('com.noorapp.noor/silent_mode');
  final calls = <String>[];
  var isExempted = false;

  setUp(() {
    calls.clear();
    isExempted = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      if (call.method == 'isIgnoringBatteryOptimizations') return isExempted;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('checks exemption status on build', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(calls, contains('isIgnoringBatteryOptimizations'));
  });

  testWidgets('shows the exempted message when already exempted', (tester) async {
    isExempted = true;
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('Allow unrestricted battery use'), findsNothing);
  });

  testWidgets(
    'shows the grant button when not exempted, and tapping it opens the '
    'system dialog',
    (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('Allow unrestricted battery use'), findsOneWidget);

      await tester.tap(find.text('Allow unrestricted battery use'));
      await tester.pumpAndSettle();

      expect(calls, contains('requestIgnoreBatteryOptimizations'));
    },
  );

  testWidgets(
    're-checks exemption status when the app resumes (user may have just '
    'granted it in system settings)',
    (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle), findsNothing);

      isExempted = true;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    },
  );
}
