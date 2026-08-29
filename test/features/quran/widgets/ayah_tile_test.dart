// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-08-29 fix: the main Quran reading
// screens are Arabic-only, deliberately — AyahTile must never render
// a translation line even when the ayah data has one (translation is
// only ever shown in search results, a different widget entirely).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/presentation/widgets/ayah_tile.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  const ayah = QuranAyah(
    surahId: 1,
    ayahNumber: 1,
    arabicText: 'بِسْمِ اللَّهِ',
    translation: 'In the name of Allah',
  );

  testWidgets('never renders translation even when the ayah has one', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AyahTile(
          ayah: ayah,
          fontScale: 1.0,
          isBookmarked: false,
          onToggleBookmark: () {},
        ),
      ),
    );

    expect(find.text('In the name of Allah'), findsNothing);
    expect(find.text('بِسْمِ اللَّهِ'), findsOneWidget);
  });

  testWidgets('Arabic text size scales with fontScale', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AyahTile(
          ayah: ayah,
          fontScale: 1.5,
          isBookmarked: false,
          onToggleBookmark: () {},
        ),
      ),
    );

    final arabic = tester.widget<Text>(find.text('بِسْمِ اللَّهِ'));
    expect(arabic.style?.fontSize, 22 * 1.5);
  });
}
