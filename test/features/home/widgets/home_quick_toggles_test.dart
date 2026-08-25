// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-08-25 fix: Settings' own Silent Mode
// section (with its "Grant Do Not Disturb access" button) was removed
// as duplicate UI, so turning Silent Mode on from Home now has to
// request that access itself, or the toggle would go on visually
// while the ringer never actually changes.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/home/presentation/widgets/home_quick_toggles.dart';
import 'package:noor/features/prayer_times/data/silent_mode_settings.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';
import 'package:noor/features/settings/logic/settings_cubit/settings_cubit.dart';

class _FakeSettingsRepository extends SettingsRepository {
  _FakeSettingsRepository(this._settings);
  AppSettings _settings;

  @override
  Future<AppSettings> load() async => _settings;

  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

Widget _wrap(SettingsCubit cubit) {
  return MaterialApp(
    home: Scaffold(
      body: BlocProvider.value(value: cubit, child: const HomeQuickToggles()),
    ),
  );
}

void main() {
  const channel = MethodChannel('com.noorapp.noor/silent_mode');
  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      if (call.method == 'hasNotificationPolicyAccess') return false;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets(
    'turning Silent Mode on requests DND access when not already granted',
    (tester) async {
      final cubit = SettingsCubit(
        repository: _FakeSettingsRepository(const AppSettings()),
      );
      await cubit.load();

      await tester.pumpWidget(_wrap(cubit));
      await tester.tap(find.text('Silent Mode'));
      await tester.pumpAndSettle();

      expect(calls, containsAllInOrder([
        'hasNotificationPolicyAccess',
        'requestNotificationPolicyAccess',
      ]));
      expect(cubit.state.settings.silentMode.fajr, isTrue);

      await cubit.close();
    },
  );

  testWidgets(
    'turning Silent Mode off does not touch the DND-access channel',
    (tester) async {
      final cubit = SettingsCubit(
        repository: _FakeSettingsRepository(
          const AppSettings(
            silentMode: SilentModeSettings(
              fajr: true,
              dhuhr: true,
              asr: true,
              maghrib: true,
              isha: true,
            ),
          ),
        ),
      );
      await cubit.load();

      await tester.pumpWidget(_wrap(cubit));
      await tester.tap(find.text('Silent Mode'));
      await tester.pumpAndSettle();

      expect(calls, isEmpty);
      expect(cubit.state.settings.silentMode.fajr, isFalse);

      await cubit.close();
    },
  );
}
