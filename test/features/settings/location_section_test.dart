// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Settings is the only place the app offers "Allow location" again:
// shown only while permission is missing, and re-checked when the app
// returns to the foreground.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/features/settings/presentation/widgets/location_section.dart';

import '../../helpers/theme_harness.dart';

class _Service extends LocationService {
  _Service(this.allowed);
  bool allowed;
  int settingsOpened = 0;

  @override
  Future<bool> hasPermission() async => allowed;

  @override
  Future<bool> isPermanentlyDenied() async => !allowed;

  @override
  Future<void> openAppSettings() async => settingsOpened++;

  @override
  Future<Coordinates?> getCurrentCoordinates({
    Duration timeout = const Duration(seconds: 10),
    bool promptIfNeeded = true,
  }) async => allowed ? const Coordinates(latitude: 1, longitude: 2) : null;
}

void main() {
  testWidgets('without permission: a small "Allow location" button and a plain caption', (tester) async {
    await tester.pumpWidget(
      themedApp(Scaffold(body: LocationSection(locationService: _Service(false))), allThemes['Nebula']!()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Allow location'), findsOneWidget);
    expect(find.textContaining('last known place'), findsOneWidget);
    expect(find.text('Use my location'), findsNothing);
  });

  testWidgets('with permission: a refresh button, no "Allow location"', (tester) async {
    await tester.pumpWidget(
      themedApp(Scaffold(body: LocationSection(locationService: _Service(true))), allThemes['Dawn']!()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Allow location'), findsNothing);
    expect(find.text('Use my location'), findsOneWidget);
  });

  testWidgets('permanently denied: tapping opens the phone settings instead of prompting', (tester) async {
    final service = _Service(false);
    await tester.pumpWidget(themedApp(Scaffold(body: LocationSection(locationService: service)), allThemes['Mushaf']!()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Allow location'));
    await tester.pumpAndSettle();

    expect(service.settingsOpened, 1);
  });

  testWidgets('picks up permission granted in phone settings when the app resumes', (tester) async {
    final service = _Service(false);
    await tester.pumpWidget(
      themedApp(Scaffold(body: LocationSection(locationService: service)), allThemes['Emerald Night']!()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Allow location'), findsOneWidget);

    service.allowed = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(find.text('Use my location'), findsOneWidget);
  });
}
