// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Page-turn pages for "Read the full Quran", built progressively:
// the first surahs' pages show within a frame or two while the rest
// are measured in the background (this used to be one ~30 s pass behind
// a spinner). Results are kept in memory for the process and on disk
// (full_quran_pagination_cache.dart), so repeat opens are instant.

import 'dart:async';

import 'package:flutter/material.dart';

import '../data/full_quran_pagination_cache.dart';
import '../data/quran_ayah.dart';
import '../data/quran_surah.dart';
import '../presentation/widgets/full_quran_page_splitter.dart';

class FullQuranPaginator extends ChangeNotifier {
  List<BookPage> pages = const [];
  bool done = false;

  int _generation = 0;
  double? _width;
  double? _height;
  double? _fontScale;
  int? _ayahCount;

  // Process-wide memory cache: reused while size, scale and count match.
  static List<BookPage>? _cachedPages;
  static double? _cachedWidth;
  static double? _cachedHeight;
  static double? _cachedFontScale;
  static int? _cachedAyahCount;

  /// Forget the in-memory cache (tests).
  static void clearMemoryCache() => _cachedPages = null;

  void ensure({
    required List<QuranAyah> ayahs,
    required List<QuranSurah> surahs,
    required TextStyle style,
    required double width,
    required double height,
    required double fontScale,
  }) {
    final w = width.roundToDouble();
    final h = height.roundToDouble();
    if (_width == w && _height == h && _fontScale == fontScale && _ayahCount == ayahs.length) {
      return;
    }
    _width = w;
    _height = h;
    _fontScale = fontScale;
    _ayahCount = ayahs.length;
    final generation = ++_generation;

    if (_cachedPages != null &&
        _cachedWidth == w &&
        _cachedHeight == h &&
        _cachedFontScale == fontScale &&
        _cachedAyahCount == ayahs.length) {
      pages = _cachedPages!;
      done = true;
      notifyListeners();
      return;
    }
    pages = const [];
    done = false;
    unawaited(_run(generation, ayahs, surahs, style, w, h, fontScale));
  }

  Future<void> _run(
    int generation,
    List<QuranAyah> ayahs,
    List<QuranSurah> surahs,
    TextStyle style,
    double width,
    double height,
    double fontScale,
  ) async {
    final onDisk = await loadFullQuranPaginationCache(
      ayahs: ayahs,
      surahs: surahs,
      width: width,
      height: height,
      fontScale: fontScale,
      ayahCount: ayahs.length,
    );
    if (generation != _generation) return;
    if (onDisk != null) {
      _finish(onDisk, width, height, fontScale, ayahs.length, save: false);
      return;
    }

    final built = <BookPage>[];
    await splitBookProgressive(
      ayahs: ayahs,
      surahs: surahs,
      style: style,
      maxWidth: width,
      maxHeight: height,
      onPages: (chunk) {
        if (generation != _generation) return false;
        built.addAll(chunk);
        pages = List<BookPage>.of(built);
        notifyListeners();
        return true;
      },
    );
    if (generation == _generation) {
      _finish(built, width, height, fontScale, ayahs.length, save: true);
    }
  }

  void _finish(
    List<BookPage> all,
    double width,
    double height,
    double fontScale,
    int ayahCount, {
    required bool save,
  }) {
    pages = all;
    done = true;
    _cachedPages = all;
    _cachedWidth = width;
    _cachedHeight = height;
    _cachedFontScale = fontScale;
    _cachedAyahCount = ayahCount;
    notifyListeners();
    if (save) {
      unawaited(saveFullQuranPaginationCache(
        pages: all,
        width: width,
        height: height,
        fontScale: fontScale,
        ayahCount: ayahCount,
      ));
    }
  }

  @override
  void dispose() {
    _generation++;
    super.dispose();
  }
}
