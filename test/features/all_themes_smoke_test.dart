// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Screens that can be built without a database render in all four
// themes at 100% and 200% text scale without layout exceptions.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/presentation/progress/progress_card.dart';
import 'package:noor/features/prayer_tracker/presentation/progress_screen.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';
import 'package:noor/features/settings/presentation/licences_screen.dart';
import 'package:noor/features/settings/presentation/send_feedback_screen.dart';
import 'package:noor/features/settings/presentation/support_developer_screen.dart';
import 'package:noor/features/zakat/presentation/zakat_screen.dart';

import '../helpers/theme_harness.dart';

class _FakeSettings extends SettingsRepository {
  @override
  Future<AppSettings> load() async => const AppSettings(profileName: 'Test');

  @override
  Future<void> save(AppSettings settings) async {}
}

class _FakeTracker extends PrayerTrackerRepository {
  @override
  Future<Map<DateTime, int>> completionCountsByDay() async {
    final now = DateTime.now();
    return {
      DateTime(now.year, now.month, now.day): 3,
      DateTime(now.year, now.month, now.day - 1): 5,
      DateTime(now.year, now.month, now.day - 2): 5,
    };
  }

  @override
  Future<List<({DateTime date, int completedCount, bool fasted})>> historyForRange(
    DateTime start,
    DateTime end,
  ) async => const [];
}

void main() {
  final screens = <String, Widget Function()>{
    'Progress card': () => Scaffold(
      body: SingleChildScrollView(child: ProgressCard(repository: _FakeTracker())),
    ),
    'Progress screen': () => ProgressScreen(
      repository: _FakeTracker(),
      settingsRepository: _FakeSettings(),
    ),
    'Zakat': () => const ZakatScreen(),
    'Licences': () => const LicencesScreen(),
    'Support': () => const SupportDeveloperScreen(),
    'Feedback': () => const SendFeedbackScreen(),
  };

  for (final theme in allThemes.entries) {
    for (final screen in screens.entries) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('${screen.key} renders in ${theme.key} at ${(scale * 100).round()}% text', (tester) async {
          tester.view.physicalSize = const Size(360 * 3, 740 * 3);
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(themedApp(screen.value(), theme.value(), textScale: scale));
          await tester.pump(const Duration(seconds: 1));

          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
