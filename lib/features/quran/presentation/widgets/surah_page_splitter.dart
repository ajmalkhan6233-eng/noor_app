// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Splits one surah's ayahs into screen-sized "pages" for the
// page-turn reader (2026-09-01, direct request: "page by page...
// turning page effect", not one continuous scroll). This is a
// reading-experience choice, not a claim about the real printed
// Mushaf's 604-page layout — no verified ayah-to-page mapping for
// that exists in this project's bundled Tanzil data (see
// continuous_surah_text.dart's header), so page breaks here are
// computed live from the actual available screen size, the same way
// an ebook reader reflows text, not looked up from a fixed table.
//
// The (n) suffix approximates AyahEndMark's measured width for this
// pass — close enough for deciding where a page should break; a few
// pixels of slack either way has no correctness consequence here,
// unlike an error in the Arabic text itself would.

import 'package:flutter/material.dart';

import '../../data/quran_ayah.dart';

List<List<QuranAyah>> splitIntoPages({
  required List<QuranAyah> ayahs,
  required TextStyle style,
  required double maxWidth,
  required double maxHeight,
}) {
  if (ayahs.isEmpty) return [];
  final pages = <List<QuranAyah>>[];
  var current = <QuranAyah>[];

  double heightOf(List<QuranAyah> group) {
    final text = group.map((a) => '${a.arabicText} (${a.ayahNumber})  ').join();
    final painter = TextPainter(
      text: TextSpan(style: style, text: text),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
    )..layout(maxWidth: maxWidth);
    return painter.height;
  }

  for (final ayah in ayahs) {
    final candidate = [...current, ayah];
    if (current.isNotEmpty && heightOf(candidate) > maxHeight) {
      pages.add(current);
      current = [ayah];
    } else {
      current = candidate;
    }
  }
  if (current.isNotEmpty) pages.add(current);
  return pages;
}
