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

import '../../data/page_packer.dart';
import '../../data/quran_ayah.dart';

/// Measures the height of a group of ayahs laid out as one justified
/// paragraph of width [maxWidth] (the same text the reader renders).
AyahGroupHeight ayahGroupHeightFor(TextStyle style, double maxWidth) {
  return (group) {
    final text = group.map((a) => '${a.arabicText} (${a.ayahNumber})  ').join();
    final painter = TextPainter(
      text: TextSpan(style: style, text: text),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
    )..layout(maxWidth: maxWidth);
    final height = painter.height;
    painter.dispose();
    return height;
  };
}

/// Synchronous split (used by tests and small inputs). Uses the
/// guess-and-verify packer, so it is much cheaper than measuring once
/// per ayah, with identical results.
List<List<QuranAyah>> splitIntoPages({
  required List<QuranAyah> ayahs,
  required TextStyle style,
  required double maxWidth,
  required double maxHeight,
}) {
  if (ayahs.isEmpty) return [];
  return packPages(
    ayahs: ayahs,
    heightOf: ayahGroupHeightFor(style, maxWidth),
    maxHeight: maxHeight,
  );
}

/// Progressive split: delivers pages in chunks and yields between
/// chunks, so the first page appears at once and the UI never freezes.
Future<void> splitIntoPagesProgressive({
  required List<QuranAyah> ayahs,
  required TextStyle style,
  required double maxWidth,
  required double maxHeight,
  required bool Function(List<List<QuranAyah>> pages) onChunk,
}) {
  return packPagesProgressive(
    ayahs: ayahs,
    heightOf: ayahGroupHeightFor(style, maxWidth),
    maxHeight: maxHeight,
    onChunk: onChunk,
  );
}
