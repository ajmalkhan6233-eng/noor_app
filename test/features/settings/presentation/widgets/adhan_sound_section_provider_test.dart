// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression coverage for the same class of bug already fixed once in
// more_screen.dart (4dbfbed, "fix ProviderNotFoundException opening
// Qibla placeholder"): Settings is a separately-pushed route, so it
// only ever gets what more_screen.dart explicitly re-provides via
// BlocProvider.value — anything read via context.read() that isn't
// re-provided there throws the moment the widget builds/is tapped.
// AdhanSoundSection reads AdhanPreviewCubit (provided only inside
// HomeDashboard's tab tree), so without the same fix applied to the
// Settings tile's route, tapping a reciter throws.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/adhan_reciter.dart';
import 'package:noor/features/prayer_times/logic/adhan_preview_cubit.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';
import 'package:noor/features/settings/logic/settings_cubit/settings_cubit.dart';
import 'package:noor/features/settings/presentation/widgets/adhan_sound_section.dart';

class _FakeSettingsRepository extends SettingsRepository {
  @override
  Future<AppSettings> load() async => const AppSettings();

  @override
  Future<void> save(AppSettings settings) async {}
}

Widget _wrap({required bool provideAdhanPreviewCubit}) {
  final settingsCubit = SettingsCubit(repository: _FakeSettingsRepository());
  final content = BlocProvider<SettingsCubit>.value(
    value: settingsCubit,
    child: const MaterialApp(home: Scaffold(body: AdhanSoundSection())),
  );
  if (!provideAdhanPreviewCubit) return content;
  return BlocProvider<AdhanPreviewCubit>.value(
    value: AdhanPreviewCubit(),
    child: content,
  );
}

void main() {
  testWidgets(
    'tapping a reciter throws ProviderNotFoundException when AdhanPreviewCubit '
    "isn't provided on this route (reproduces the bug — same missing-provider "
    'shape as the Qibla ProviderNotFoundException fix)',
    (tester) async {
      await tester.pumpWidget(_wrap(provideAdhanPreviewCubit: false));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AdhanReciter.doha.label).first);
      await tester.pump();

      final error = tester.takeException();
      expect(error, isNotNull);
      expect(error.toString(), contains('AdhanPreviewCubit'));
    },
  );

  testWidgets(
    'tapping a reciter works with no exception once AdhanPreviewCubit is '
    'provided on this route (confirms the fix)',
    (tester) async {
      await tester.pumpWidget(_wrap(provideAdhanPreviewCubit: true));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AdhanReciter.doha.label).first);
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );
}
