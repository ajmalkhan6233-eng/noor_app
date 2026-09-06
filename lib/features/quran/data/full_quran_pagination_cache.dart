// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Persists the "Read the full Quran" whole-book pagination result to
// disk (2026-09-05, direct request) — the in-memory cache in
// PaginatedFullQuranText only survives while the app process is
// alive, so the ~30s first-pass measurement (see
// full_quran_page_splitter.dart) still had to redo itself every time
// the app was killed and reopened. This stores just the page
// boundaries (surah id + ayah numbers per page), not the ayah text
// itself, and is invalidated automatically if the layout size, font
// scale, or ayah count ever change.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/widgets/full_quran_page_splitter.dart';
import 'quran_ayah.dart';
import 'quran_surah.dart';

const _cacheKey = 'full_quran_pagination_cache_v1';

Future<void> saveFullQuranPaginationCache({
  required List<BookPage> pages,
  required double width,
  required double height,
  required double fontScale,
  required int ayahCount,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final json = jsonEncode({
    'width': width,
    'height': height,
    'fontScale': fontScale,
    'ayahCount': ayahCount,
    'pages': [
      for (final page in pages)
        {
          'surahId': page.surah.id,
          'first': page.isFirstPageOfSurah,
          'ayahs': [for (final a in page.ayahs) a.ayahNumber],
        },
    ],
  });
  await prefs.setString(_cacheKey, json);
}

/// Returns the cached pages if a cache exists and matches the given
/// layout/font/ayah-count exactly, otherwise `null`.
Future<List<BookPage>?> loadFullQuranPaginationCache({
  required List<QuranAyah> ayahs,
  required List<QuranSurah> surahs,
  required double width,
  required double height,
  required double fontScale,
  required int ayahCount,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_cacheKey);
  if (raw == null) return null;

  final Map<String, dynamic> decoded;
  try {
    decoded = jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }

  if (decoded['width'] != width ||
      decoded['height'] != height ||
      decoded['fontScale'] != fontScale ||
      decoded['ayahCount'] != ayahCount) {
    return null;
  }

  final surahsById = {for (final s in surahs) s.id: s};
  final ayahsByKey = {for (final a in ayahs) '${a.surahId}:${a.ayahNumber}': a};

  final pages = <BookPage>[];
  for (final rawPage in decoded['pages'] as List) {
    final page = rawPage as Map<String, dynamic>;
    final surahId = page['surahId'] as int;
    final surah = surahsById[surahId];
    if (surah == null) return null;
    final pageAyahs = <QuranAyah>[];
    for (final ayahNumber in page['ayahs'] as List) {
      final ayah = ayahsByKey['$surahId:$ayahNumber'];
      if (ayah == null) return null;
      pageAyahs.add(ayah);
    }
    pages.add(BookPage(surah: surah, ayahs: pageAyahs, isFirstPageOfSurah: page['first'] as bool));
  }
  return pages;
}
