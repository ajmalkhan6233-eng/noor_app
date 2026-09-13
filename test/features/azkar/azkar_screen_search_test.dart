// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-09-12 "search results not clickable"
// fix: _openCategory() was reading AzkarCubit from the State's own
// context, which sits *above* the BlocProvider created inside that
// same build() call — a lookup that can never succeed. This test
// exercises the real tap path end to end (type a query, tap a result,
// confirm the category screen actually opens) so this exact class of
// bug — a silent ProviderNotFoundException inside an onTap callback,
// with no visible crash — gets caught by the suite even without a
// physical device.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_category.dart';
import 'package:noor/features/azkar/data/azkar_item.dart';
import 'package:noor/features/azkar/data/azkar_repository.dart';
import 'package:noor/features/azkar/presentation/azkar_category_screen.dart';
import 'package:noor/features/azkar/presentation/azkar_screen.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

class _FakeSearchRepository extends AzkarRepository {
  @override
  Future<List<(AzkarCategory category, AzkarItem item)>> searchItems(String query) async {
    if (!query.toLowerCase().contains('sleep')) return [];
    return const [
      (
        AzkarCategory.sleep,
        AzkarItem(
          id: 1,
          arabicText: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          transliteration: 'Bismika Allahumma amutu wa ahya',
          translation: 'In Your name, O Allah, I die and I live.',
          repeatCount: 1,
          source: 'Test',
        ),
      ),
    ];
  }
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets(
    'tapping a search result opens that dua\'s category screen',
    (tester) async {
      await tester.pumpWidget(_wrap(AzkarScreen(repository: _FakeSearchRepository())));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'sleeping');
      await tester.pump();

      expect(find.text('Sleep'), findsOneWidget);

      await tester.tap(find.text('Sleep'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AzkarCategoryScreen), findsOneWidget);
    },
  );
}
