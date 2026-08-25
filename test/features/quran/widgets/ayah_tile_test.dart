// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-08-25 fix: translation text must scale
// with fontScale, not just the Arabic line.

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

  testWidgets('translation font size scales with fontScale', (tester) async {
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

    final translation = tester.widget<Text>(
      find.text('In the name of Allah'),
    );
    expect(translation.style?.fontSize, 14 * 1.5);

    final arabic = tester.widget<Text>(find.text('بِسْمِ اللَّهِ'));
    expect(arabic.style?.fontSize, 22 * 1.5);
  });

  testWidgets('defaults to base sizes at fontScale 1.0', (tester) async {
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

    final translation = tester.widget<Text>(
      find.text('In the name of Allah'),
    );
    expect(translation.style?.fontSize, 14);
  });
}
