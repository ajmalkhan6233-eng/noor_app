// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The first-run permission flow: one button, three requests back to
// back in a fixed order, answers remembered, a "no" never blocks the
// rest, and the welcome screen shows once with a single action.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/permissions/permission_gateway.dart';
import 'package:noor/core/permissions/permission_onboarding.dart';
import 'package:noor/core/presentation/location_onboarding_screen.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/theme_harness.dart';

class _FakeGateway implements PermissionGateway {
  _FakeGateway({this.location = true, this.exact, this.throwOnLocation = false});

  final bool location;
  final bool notifications = true;
  final bool? exact;
  final bool throwOnLocation;
  final List<String> asked = [];

  @override
  Future<bool> requestLocation() async {
    asked.add('location');
    if (throwOnLocation) throw StateError('prompt failed');
    return location;
  }

  @override
  Future<bool> requestNotifications() async {
    asked.add('notifications');
    return notifications;
  }

  @override
  Future<bool?> requestExactAlarm() async {
    asked.add('exact');
    return exact;
  }
}

class _MemorySettings extends SettingsRepository {
  AppSettings current = const AppSettings();

  @override
  Future<AppSettings> load() async => current;

  @override
  Future<void> save(AppSettings settings) async => current = settings;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('PermissionOnboarding', () {
    test('asks location, then notifications, then exact alarms, in that order', () async {
      final gateway = _FakeGateway(exact: true);
      final results = await PermissionOnboarding(gateway: gateway).run();

      expect(gateway.asked, ['location', 'notifications', 'exact']);
      expect(results.location && results.notifications && results.exactAlarm!, isTrue);
    });

    test('a denied location does not stop the next requests, and is remembered', () async {
      final gateway = _FakeGateway(location: false);
      final results = await PermissionOnboarding(gateway: gateway).run();

      expect(gateway.asked, ['location', 'notifications', 'exact']);
      expect(results.location, isFalse);
      expect(results.notifications, isTrue);
      expect(results.exactAlarm, isNull, reason: 'phone did not need the exact-alarm grant');

      final recalled = await PermissionOnboarding.recall();
      expect(recalled, isNotNull);
      expect(recalled!.location, isFalse);
      expect(recalled.notifications, isTrue);
    });

    test('a prompt that throws is treated as "no" and the flow continues', () async {
      final gateway = _FakeGateway(throwOnLocation: true);
      final results = await PermissionOnboarding(gateway: gateway).run();

      expect(results.location, isFalse);
      expect(gateway.asked, contains('notifications'));
    });

    test('nothing is remembered before the first run', () async {
      expect(await PermissionOnboarding.recall(), isNull);
    });
  });

  group('Welcome screen', () {
    testWidgets('has one action; tapping it runs the flow once and finishes', (tester) async {
      tester.view.physicalSize = const Size(360 * 3, 740 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final gateway = _FakeGateway();
      final settings = _MemorySettings();
      var finished = 0;

      await tester.pumpWidget(
        themedApp(
          LocationOnboardingScreen(
            onFinished: () => finished++,
            gateway: gateway,
            settingsRepository: settings,
          ),
          allThemes['Dawn']!(),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing, reason: 'no skip / not-now buttons');

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      expect(gateway.asked, ['location', 'notifications', 'exact']);
      expect(finished, 1);
      expect(settings.current.hasSeenLocationOnboarding, isTrue);
    });

    testWidgets('a second tap while working does not ask twice', (tester) async {
      final gateway = _FakeGateway();
      await tester.pumpWidget(
        themedApp(
          LocationOnboardingScreen(onFinished: () {}, gateway: gateway, settingsRepository: _MemorySettings()),
          allThemes['Nebula']!(),
        ),
      );
      await tester.tap(find.text('Get started'));
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(gateway.asked.where((a) => a == 'location').length, 1);
    });

    for (final theme in allThemes.entries) {
      testWidgets('renders in ${theme.key} at 200% text without overflow', (tester) async {
        tester.view.physicalSize = const Size(360 * 3, 740 * 3);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          themedApp(
            LocationOnboardingScreen(onFinished: () {}, gateway: _FakeGateway(), settingsRepository: _MemorySettings()),
            theme.value(),
            textScale: 2.0,
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    }
  });
}
