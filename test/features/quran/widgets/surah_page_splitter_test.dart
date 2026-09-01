// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/presentation/widgets/surah_page_splitter.dart';

void main() {
  const style = TextStyle(fontSize: 22, height: 2.1);

  test('a short surah fits entirely on one page', () {
    final ayahs = [
      const QuranAyah(surahId: 112, ayahNumber: 1, arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ'),
      const QuranAyah(surahId: 112, ayahNumber: 2, arabicText: 'اللَّهُ الصَّمَدُ'),
      const QuranAyah(surahId: 112, ayahNumber: 3, arabicText: 'لَمْ يَلِدْ وَلَمْ يُولَدْ'),
      const QuranAyah(surahId: 112, ayahNumber: 4, arabicText: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ'),
    ];

    final pages = splitIntoPages(ayahs: ayahs, style: style, maxWidth: 300, maxHeight: 2000);

    expect(pages, hasLength(1));
    expect(pages.single, ayahs);
  });

  test('a very short page height forces a new page per ayah', () {
    final ayahs = [
      const QuranAyah(surahId: 112, ayahNumber: 1, arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ'),
      const QuranAyah(surahId: 112, ayahNumber: 2, arabicText: 'اللَّهُ الصَّمَدُ'),
      const QuranAyah(surahId: 112, ayahNumber: 3, arabicText: 'لَمْ يَلِدْ وَلَمْ يُولَدْ'),
    ];

    final pages = splitIntoPages(ayahs: ayahs, style: style, maxWidth: 300, maxHeight: 40);

    expect(pages.length, 3);
    expect(pages.every((p) => p.length == 1), isTrue);
  });

  test('every ayah appears exactly once across all pages, in order', () {
    final ayahs = List.generate(
      20,
      (i) => QuranAyah(surahId: 2, ayahNumber: i + 1, arabicText: 'نَص آية رقم ${i + 1}'),
    );

    final pages = splitIntoPages(ayahs: ayahs, style: style, maxWidth: 300, maxHeight: 100);
    final flattened = pages.expand((p) => p).toList();

    expect(flattened.map((a) => a.ayahNumber).toList(), List.generate(20, (i) => i + 1));
  });

  test('an empty ayah list produces no pages', () {
    expect(splitIntoPages(ayahs: const [], style: style, maxWidth: 300, maxHeight: 500), isEmpty);
  });
}
