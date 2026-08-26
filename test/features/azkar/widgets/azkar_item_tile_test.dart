// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-08-25 fix: Azkar text was hardcoded
// and ignored the Quran text-size setting entirely — fontScale must
// now reach the Arabic, transliteration, and translation lines.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_item.dart';
import 'package:noor/features/azkar/logic/azkar_cubit/azkar_cubit.dart';
import 'package:noor/features/azkar/presentation/widgets/azkar_item_tile.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider(create: (_) => AzkarCubit(), child: child),
    ),
  );
}

void main() {
  const item = AzkarItem(
    id: 1,
    arabicText: 'سُبْحَانَ اللَّهِ',
    transliteration: 'SubhanAllah',
    translation: 'Glory be to Allah',
    repeatCount: 3,
    source: 'Sahih Muslim',
  );

  testWidgets('text sizes scale with fontScale', (tester) async {
    await tester.pumpWidget(_wrap(AzkarItemTile(item: item, fontScale: 1.5)));

    final arabic = tester.widget<Text>(find.text('سُبْحَانَ اللَّهِ'));
    expect(arabic.style?.fontSize, 26 * 1.5);

    final transliteration = tester.widget<Text>(find.text('SubhanAllah'));
    expect(transliteration.style?.fontSize, 13 * 1.5);

    final translation = tester.widget<Text>(find.text('Glory be to Allah'));
    expect(translation.style?.fontSize, 12 * 1.5);
  });

  testWidgets('defaults to fontScale 1.0 when not provided', (tester) async {
    await tester.pumpWidget(_wrap(AzkarItemTile(item: item)));

    final arabic = tester.widget<Text>(find.text('سُبْحَانَ اللَّهِ'));
    expect(arabic.style?.fontSize, 26);
  });

  testWidgets('shows the hadith source citation', (tester) async {
    await tester.pumpWidget(_wrap(AzkarItemTile(item: item)));

    expect(find.textContaining('Sahih Muslim'), findsOneWidget);
  });
}
