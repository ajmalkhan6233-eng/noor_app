// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/presentation/widgets/ayah_end_mark.dart';
import 'package:noor/features/quran/presentation/widgets/continuous_surah_text.dart';

const _ayahs = [
  QuranAyah(surahId: 1, ayahNumber: 1, arabicText: 'بِسْمِ اللَّهِ'),
  QuranAyah(surahId: 1, ayahNumber: 2, arabicText: 'الْحَمْدُ لِلَّهِ'),
  QuranAyah(surahId: 1, ayahNumber: 3, arabicText: 'الرَّحْمَٰنِ الرَّحِيمِ'),
];

void main() {
  final keys = <int, GlobalKey>{};
  GlobalKey keyFor(int ayahNumber) => keys.putIfAbsent(ayahNumber, GlobalKey.new);

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

  testWidgets('renders every ayah as one continuous RichText, no per-ayah cards', (tester) async {
    await tester.pumpWidget(
      wrap(ContinuousSurahText(
        ayahs: _ayahs,
        fontScale: 1.0,
        bookmarkedAyahNumbers: const {},
        onToggleBookmark: (_) {},
        ayahKeyFor: keyFor,
      )),
    );

    expect(find.byType(RichText), findsWidgets);
    expect(find.byType(AyahEndMark), findsNWidgets(3));
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('tapping an ayah end mark reports that ayah number', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      wrap(ContinuousSurahText(
        ayahs: _ayahs,
        fontScale: 1.0,
        bookmarkedAyahNumbers: const {},
        onToggleBookmark: (n) => tapped = n,
        ayahKeyFor: keyFor,
      )),
    );

    await tester.tap(find.byType(AyahEndMark).at(1));
    expect(tapped, 2);
  });

  testWidgets('bookmarked ayahs render with a filled mark', (tester) async {
    await tester.pumpWidget(
      wrap(ContinuousSurahText(
        ayahs: _ayahs,
        fontScale: 1.0,
        bookmarkedAyahNumbers: const {2},
        onToggleBookmark: (_) {},
        ayahKeyFor: keyFor,
      )),
    );

    final marks = tester.widgetList<AyahEndMark>(find.byType(AyahEndMark)).toList();
    expect(marks.firstWhere((m) => m.ayahNumber == 2).isBookmarked, isTrue);
    expect(marks.firstWhere((m) => m.ayahNumber == 1).isBookmarked, isFalse);
  });

  testWidgets('each ayah gets its own key for reading-position tracking', (tester) async {
    keys.clear();
    await tester.pumpWidget(
      wrap(ContinuousSurahText(
        ayahs: _ayahs,
        fontScale: 1.0,
        bookmarkedAyahNumbers: const {},
        onToggleBookmark: (_) {},
        ayahKeyFor: keyFor,
      )),
    );

    for (final ayah in _ayahs) {
      expect(keys[ayah.ayahNumber]?.currentContext, isNotNull);
    }
  });
}
