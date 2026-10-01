// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure page-packing maths for the page-turn readers (no Flutter, no
// text layout of its own): given a function that measures a group of
// ayahs, find how many ayahs fit on one page.
//
// The old splitter laid out the growing page text once per ayah. Here
// the previous page's size is the starting guess, so a page usually
// costs two measurements instead of one per ayah. The result is
// identical (the largest prefix that fits, never fewer than one ayah)
// because a group's height never shrinks when an ayah is added.

import 'quran_ayah.dart';

typedef AyahGroupHeight = double Function(List<QuranAyah> group);

/// How many ayahs starting at [start] fit within [maxHeight] (>= 1).
/// [guess] is the expected count, e.g. the previous page's size.
int fitCount({
  required List<QuranAyah> ayahs,
  required int start,
  required AyahGroupHeight heightOf,
  required double maxHeight,
  int guess = 4,
}) {
  final remaining = ayahs.length - start;
  if (remaining <= 1) return remaining;

  bool fits(int count) =>
      count <= 1 || heightOf(ayahs.sublist(start, start + count)) <= maxHeight;

  var k = guess.clamp(1, remaining);
  if (fits(k)) {
    while (k < remaining && fits(k + 1)) {
      k++;
    }
    return k;
  }
  // [k] does not fit: binary search the largest count that does.
  var low = 1;
  var high = k;
  while (high - low > 1) {
    final mid = (low + high) ~/ 2;
    if (fits(mid)) {
      low = mid;
    } else {
      high = mid;
    }
  }
  return low;
}

/// Splits all [ayahs] into pages using [fitCount].
List<List<QuranAyah>> packPages({
  required List<QuranAyah> ayahs,
  required AyahGroupHeight heightOf,
  required double maxHeight,
}) {
  final pages = <List<QuranAyah>>[];
  var start = 0;
  var guess = 4;
  while (start < ayahs.length) {
    final count = fitCount(
      ayahs: ayahs,
      start: start,
      heightOf: heightOf,
      maxHeight: maxHeight,
      guess: guess,
    );
    pages.add(ayahs.sublist(start, start + count));
    start += count;
    guess = count;
  }
  return pages;
}

/// Like [packPages] but hands pages over in chunks and yields to the
/// event loop between chunks (about [budgetMs] of work each), so the UI
/// keeps animating and the first page can be shown immediately.
/// [onChunk] returns false to cancel.
Future<void> packPagesProgressive({
  required List<QuranAyah> ayahs,
  required AyahGroupHeight heightOf,
  required double maxHeight,
  required bool Function(List<List<QuranAyah>> pages) onChunk,
  int budgetMs = 8,
}) async {
  final watch = Stopwatch()..start();
  var chunk = <List<QuranAyah>>[];
  var start = 0;
  var guess = 4;
  while (start < ayahs.length) {
    final count = fitCount(
      ayahs: ayahs,
      start: start,
      heightOf: heightOf,
      maxHeight: maxHeight,
      guess: guess,
    );
    chunk.add(ayahs.sublist(start, start + count));
    start += count;
    guess = count;
    final isFirst = start == count;
    if (start < ayahs.length && (isFirst || watch.elapsedMilliseconds >= budgetMs)) {
      if (!onChunk(chunk)) return;
      chunk = <List<QuranAyah>>[];
      await Future<void>.delayed(Duration.zero);
      watch.reset();
    }
  }
  if (chunk.isNotEmpty) onChunk(chunk);
}
