// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor/core/constants/app_theme.dart';
import 'package:noor/features/prayer_tracker/data/prayer_tracker_repository.dart';
import 'package:noor/features/prayer_tracker/presentation/progress/progress_card.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

class _FakeRepo extends PrayerTrackerRepository {
  _FakeRepo(this._counts);
  final Map<DateTime, int> _counts;

  @override
  Future<Map<DateTime, int>> completionCountsByDay() async => _counts;
}

Widget _wrap(Widget child) => MaterialApp(
  theme: buildLightTheme(),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows today ring, percent, and opens the help sheet', (tester) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    await tester.pumpWidget(_wrap(ProgressCard(repository: _FakeRepo({today: 5}))));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('5/5'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('All five prayers today. May Allah accept them.'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('How is this calculated?'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('How your progress is worked out'), findsOneWidget);
  });

  testWidgets('empty history shows 0% and the starter line', (tester) async {
    await tester.pumpWidget(_wrap(ProgressCard(repository: _FakeRepo(const {}))));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('0/5'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
  });
}
