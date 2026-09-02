// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Covers the 2026-09-02 direct request: the name-entry card should
// transform the page rather than sit there permanently. Three cases —
// first-time entry shows the card, saving reveals the name-header
// layout, and reopening with a name already saved skips the card.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/presentation/progress_screen.dart';
import 'package:noor/features/prayer_tracker/presentation/widgets/profile_name_header.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';

class _FakeSettingsRepository extends SettingsRepository {
  _FakeSettingsRepository(this._settings);
  AppSettings _settings;

  @override
  Future<AppSettings> load() async => _settings;

  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

class _EmptyPrayerTrackerRepository extends PrayerTrackerRepository {
  @override
  Future<List<({DateTime date, int completedCount, bool fasted})>> historyForRange(
    DateTime start,
    DateTime end,
  ) async => const [];
}

Widget _wrap({required SettingsRepository settingsRepository}) {
  return MaterialApp(
    home: ProgressScreen(
      repository: _EmptyPrayerTrackerRepository(),
      settingsRepository: settingsRepository,
    ),
  );
}

void main() {
  testWidgets('first-time (no name saved) shows the entry card', (tester) async {
    await tester.pumpWidget(
      _wrap(settingsRepository: _FakeSettingsRepository(const AppSettings())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add a name'), findsOneWidget);
    expect(find.byType(ProfileNameHeader), findsNothing);
    expect(find.text('Progress'), findsOneWidget);
  });

  testWidgets('saving a name dismisses the card and reveals the name header', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(settingsRepository: _FakeSettingsRepository(const AppSettings())),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Ajmal');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Add a name'), findsNothing);
    expect(find.byType(ProfileNameHeader), findsOneWidget);
    expect(find.text('Ajmal'), findsOneWidget);
  });

  testWidgets('a previously saved name skips the entry card entirely on load', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        settingsRepository: _FakeSettingsRepository(
          const AppSettings(profileName: 'Ajmal'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add a name'), findsNothing);
    expect(find.byType(ProfileNameHeader), findsOneWidget);
    expect(find.text('Ajmal'), findsOneWidget);
  });

  testWidgets('tapping the name header re-opens the card for editing', (tester) async {
    await tester.pumpWidget(
      _wrap(
        settingsRepository: _FakeSettingsRepository(
          const AppSettings(profileName: 'Ajmal'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ProfileNameHeader));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Ajmal'), findsOneWidget);
  });
}
