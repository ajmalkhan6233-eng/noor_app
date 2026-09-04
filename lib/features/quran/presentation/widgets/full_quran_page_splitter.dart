// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Same reflow-at-render-time pagination as surah_page_splitter.dart,
// extended across every surah so "Read the full Quran" gets the same
// page-turn treatment as the per-surah reader (2026-09-03, direct
// request after the per-surah reader shipped: "convert [the full
// Quran view] to page-turn too"). A page never spans two surahs — a
// new surah always starts its own fresh page, both because that's how
// a reader naturally expects chapter boundaries to work and because
// it avoids needing to fit a surah's header (name + audio button)
// mid-page. Not real 604-page Mushaf pagination, same caveat as
// surah_page_splitter.dart.

import 'package:flutter/material.dart';

import '../../data/quran_ayah.dart';
import '../../data/quran_surah.dart';
import 'surah_page_splitter.dart';

class BookPage {
  const BookPage({
    required this.surah,
    required this.ayahs,
    required this.isFirstPageOfSurah,
  });

  final QuranSurah surah;
  final List<QuranAyah> ayahs;
  final bool isFirstPageOfSurah;
}

/// Estimated height of a surah section's header row (name + audio
/// button) — reserved only on each surah's first page, where the
/// header actually renders alongside the ayah text. A few pixels of
/// slack has no correctness consequence, same tolerance as
/// surah_page_splitter.dart's own (n)-suffix approximation.
const double surahHeaderReservedHeight = 64;

List<BookPage> splitBookIntoPages({
  required List<QuranAyah> ayahs,
  required List<QuranSurah> surahs,
  required TextStyle style,
  required double maxWidth,
  required double maxHeight,
}) {
  final surahsById = {for (final s in surahs) s.id: s};
  final pages = <BookPage>[];
  var i = 0;
  while (i < ayahs.length) {
    final surahId = ayahs[i].surahId;
    final surah = surahsById[surahId] ?? QuranSurah(id: surahId, ayahCount: 0);
    final surahAyahs = <QuranAyah>[];
    while (i < ayahs.length && ayahs[i].surahId == surahId) {
      surahAyahs.add(ayahs[i]);
      i++;
    }

    final firstPagePortion = splitIntoPages(
      ayahs: surahAyahs,
      style: style,
      maxWidth: maxWidth,
      maxHeight: maxHeight - surahHeaderReservedHeight,
    );
    if (firstPagePortion.isEmpty) continue;
    pages.add(BookPage(surah: surah, ayahs: firstPagePortion.first, isFirstPageOfSurah: true));

    final rest = surahAyahs.sublist(firstPagePortion.first.length);
    final restPages = splitIntoPages(
      ayahs: rest,
      style: style,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    for (final page in restPages) {
      pages.add(BookPage(surah: surah, ayahs: page, isFirstPageOfSurah: false));
    }
  }
  return pages;
}

/// Index of the page containing [surahId]/[ayahNumber], or -1 if not
/// found (or either argument is null) — used to jump straight to a
/// saved reading position instead of always opening at page 0.
int findInitialPageIndex(List<BookPage> pages, int? surahId, int? ayahNumber) {
  if (surahId == null || ayahNumber == null) return -1;
  return pages.indexWhere(
    (p) => p.surah.id == surahId && p.ayahs.any((a) => a.ayahNumber == ayahNumber),
  );
}
