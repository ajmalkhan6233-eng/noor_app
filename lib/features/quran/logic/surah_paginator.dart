// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Builds the page-turn pages of one surah progressively: the first page
// is available after a single measurement, the rest follow in small
// chunks that yield to the UI. A new layout size, font scale or ayah
// count restarts the work (the old run stops at its next chunk).

import 'package:flutter/material.dart';

import '../data/quran_ayah.dart';
import '../presentation/widgets/surah_page_splitter.dart';

class SurahPaginator extends ChangeNotifier {
  List<List<QuranAyah>> pages = const [];
  bool done = false;

  int _generation = 0;
  double? _width;
  double? _height;
  double? _fontScale;
  int? _ayahCount;

  /// Starts (or restarts) pagination when the inputs changed. Safe to
  /// call on every build; must not be called *during* build.
  void ensure({
    required List<QuranAyah> ayahs,
    required TextStyle style,
    required double width,
    required double height,
    required double fontScale,
  }) {
    final w = width.roundToDouble();
    final h = height.roundToDouble();
    if (_width == w &&
        _height == h &&
        _fontScale == fontScale &&
        _ayahCount == ayahs.length) {
      return;
    }
    _width = w;
    _height = h;
    _fontScale = fontScale;
    _ayahCount = ayahs.length;
    final generation = ++_generation;
    pages = const [];
    done = false;
    _run(generation, ayahs, style, w, h);
  }

  Future<void> _run(
    int generation,
    List<QuranAyah> ayahs,
    TextStyle style,
    double width,
    double height,
  ) async {
    await splitIntoPagesProgressive(
      ayahs: ayahs,
      style: style,
      maxWidth: width,
      maxHeight: height,
      onChunk: (chunk) {
        if (generation != _generation) return false;
        pages = [...pages, ...chunk];
        notifyListeners();
        return true;
      },
    );
    if (generation == _generation) {
      done = true;
      notifyListeners();
    }
  }

  /// Index of the page holding [ayahNumber], or -1 if not (yet) built.
  int pageIndexOf(int ayahNumber) =>
      pages.indexWhere((p) => p.any((a) => a.ayahNumber == ayahNumber));

  @override
  void dispose() {
    _generation++;
    super.dispose();
  }
}
