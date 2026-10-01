// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the Quran slowness: the old splitter measured the
// growing page once per ayah (~30 s for the whole Quran on a phone).
// The packer must give the same pages with far fewer measurements.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/page_packer.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';

List<QuranAyah> _ayahs(int count) => [
  for (var i = 1; i <= count; i++)
    QuranAyah(surahId: 2, ayahNumber: i, arabicText: 'x' * (20 + (i * 37) % 160)),
];

/// A monotone stand-in for text layout: one 30px line per 40 chars.
class _Meter {
  int calls = 0;
  double call(List<QuranAyah> group) {
    calls++;
    final chars = group.fold<int>(0, (sum, a) => sum + a.arabicText.length + 6);
    return (chars / 40).ceil() * 30.0;
  }
}

/// The original algorithm: measure the growing page once per ayah.
List<List<QuranAyah>> _naive(List<QuranAyah> ayahs, AyahGroupHeight h, double max) {
  final pages = <List<QuranAyah>>[];
  var current = <QuranAyah>[];
  for (final ayah in ayahs) {
    final candidate = [...current, ayah];
    if (current.isNotEmpty && h(candidate) > max) {
      pages.add(current);
      current = [ayah];
    } else {
      current = candidate;
    }
  }
  if (current.isNotEmpty) pages.add(current);
  return pages;
}

List<List<int>> _numbers(List<List<QuranAyah>> pages) =>
    [for (final p in pages) [for (final a in p) a.ayahNumber]];

void main() {
  for (final maxHeight in [60.0, 150.0, 400.0, 900.0]) {
    test('same pages as the naive algorithm at height $maxHeight', () {
      final ayahs = _ayahs(286);
      final expected = _naive(ayahs, _Meter().call, maxHeight);
      final actual = packPages(ayahs: ayahs, heightOf: _Meter().call, maxHeight: maxHeight);
      expect(_numbers(actual), _numbers(expected));
    });
  }

  test('an ayah taller than a page still gets its own page', () {
    final ayahs = _ayahs(5);
    final pages = packPages(ayahs: ayahs, heightOf: _Meter().call, maxHeight: 1);
    expect(pages.length, 5);
  }, );

  test('far fewer measurements than one per ayah on a long surah', () {
    final ayahs = _ayahs(286);
    final naive = _Meter();
    _naive(ayahs, naive.call, 400);
    final fast = _Meter();
    packPages(ayahs: ayahs, heightOf: fast.call, maxHeight: 400);
    // ignore: avoid_print
    print('measurements: naive ${naive.calls}, packer ${fast.calls}');
    expect(fast.calls, lessThan(naive.calls * 0.7));
  });

  test('progressive packing delivers the first page before the rest', () async {
    final ayahs = _ayahs(286);
    final chunks = <int>[];
    await packPagesProgressive(
      ayahs: ayahs,
      heightOf: _Meter().call,
      maxHeight: 400,
      budgetMs: 0,
      onChunk: (pages) {
        chunks.add(pages.length);
        return true;
      },
    );
    expect(chunks.length, greaterThan(2));
    expect(chunks.first, 1, reason: 'first page is handed over on its own');
    final total = chunks.fold<int>(0, (a, b) => a + b);
    expect(total, _naive(ayahs, _Meter().call, 400).length);
  });

  test('returning false from onChunk cancels the work', () async {
    var calls = 0;
    await packPagesProgressive(
      ayahs: _ayahs(286),
      heightOf: _Meter().call,
      maxHeight: 100,
      budgetMs: 0,
      onChunk: (_) => ++calls < 2,
    );
    expect(calls, 2);
  });
}
