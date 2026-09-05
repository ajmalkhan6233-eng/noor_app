// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-09-05 fix: splitBookIntoPages became
// async/chunked (yielding between surahs) so the whole-book measurement
// pass no longer blocks the UI thread in one uninterrupted call. This
// covers the async contract and that pagination results stay correct
// across the yield points.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/data/quran_surah.dart';
import 'package:noor/features/quran/presentation/widgets/full_quran_page_splitter.dart';

void main() {
  const style = TextStyle(fontSize: 22, height: 2.1);

  test('a new surah always starts its own fresh page', () async {
    final ayahs = [
      const QuranAyah(surahId: 112, ayahNumber: 1, arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ'),
      const QuranAyah(surahId: 112, ayahNumber: 2, arabicText: 'اللَّهُ الصَّمَدُ'),
      const QuranAyah(surahId: 113, ayahNumber: 1, arabicText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ'),
    ];
    final surahs = [
      const QuranSurah(id: 112, ayahCount: 2),
      const QuranSurah(id: 113, ayahCount: 1),
    ];

    final pages = await splitBookIntoPages(
      ayahs: ayahs,
      surahs: surahs,
      style: style,
      maxWidth: 300,
      maxHeight: 2000,
    );

    expect(pages.length, 2);
    expect(pages[0].surah.id, 112);
    expect(pages[0].isFirstPageOfSurah, isTrue);
    expect(pages[1].surah.id, 113);
    expect(pages[1].isFirstPageOfSurah, isTrue);
  });

  test('every ayah across multiple surahs appears exactly once, in order', () async {
    final ayahs = [
      ...List.generate(
        10,
        (i) => QuranAyah(surahId: 2, ayahNumber: i + 1, arabicText: 'نَص آية رقم ${i + 1}'),
      ),
      ...List.generate(
        5,
        (i) => QuranAyah(surahId: 3, ayahNumber: i + 1, arabicText: 'نَص آية أخرى رقم ${i + 1}'),
      ),
    ];
    final surahs = [
      const QuranSurah(id: 2, ayahCount: 10),
      const QuranSurah(id: 3, ayahCount: 5),
    ];

    final pages = await splitBookIntoPages(
      ayahs: ayahs,
      surahs: surahs,
      style: style,
      maxWidth: 300,
      maxHeight: 100,
    );
    final flattened = pages.expand((p) => p.ayahs).toList();

    expect(flattened.where((a) => a.surahId == 2).map((a) => a.ayahNumber).toList(), List.generate(10, (i) => i + 1));
    expect(flattened.where((a) => a.surahId == 3).map((a) => a.ayahNumber).toList(), List.generate(5, (i) => i + 1));
  });

  test('an empty ayah list produces no pages', () async {
    final pages = await splitBookIntoPages(
      ayahs: const [],
      surahs: const [],
      style: style,
      maxWidth: 300,
      maxHeight: 500,
    );
    expect(pages, isEmpty);
  });
}
