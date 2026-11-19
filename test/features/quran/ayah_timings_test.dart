// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/ayah_timings.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/presentation/widgets/continuous_surah_text.dart';

void main() {
  test('parses surah timings and looks up ayah starts', () {
    final t = parseAyahTimings('{"surahs": {"112": [0, 6200, 9100, 12300]}}');
    expect(ayahStart(t, 112, 1), Duration.zero);
    expect(ayahStart(t, 112, 3), const Duration(milliseconds: 9100));
    expect(ayahStart(t, 112, 5), isNull);
    expect(ayahStart(t, 113, 1), isNull);
  });

  test('a surah whose starts are not increasing is dropped', () {
    final t = parseAyahTimings('{"surahs": {"112": [0, 6200, 6100, 12300], "113": [0, 10]}}');
    expect(t.containsKey(112), isFalse);
    expect(t.containsKey(113), isTrue);
  });

  test('bundled timings file parses and matches Tanzil ayah counts', () {
    final table = parseAyahTimings(File(ayahTimingsAsset).readAsStringSync());
    final counts = <int, int>{};
    for (final line in File('assets/quran/tanzil-uthmani.txt').readAsLinesSync()) {
      final parts = line.split('|');
      if (parts.length == 3) counts[int.parse(parts[0])] = (counts[int.parse(parts[0])] ?? 0) + 1;
    }
    table.forEach((surah, starts) => expect(starts.length, counts[surah], reason: 'surah $surah'));
  });

  testWidgets('tapping an ayah\'s text plays from that ayah; no handler = not tappable', (tester) async {
    const ayahs = [
      QuranAyah(surahId: 1, ayahNumber: 1, arabicText: 'a'),
      QuranAyah(surahId: 1, ayahNumber: 2, arabicText: 'b'),
    ];
    int? played;
    Future<void> pump(ValueChanged<int>? onPlay) => tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: ContinuousSurahText(
              ayahs: ayahs,
              fontScale: 1,
              bookmarkedAyahNumbers: const {},
              onToggleBookmark: (_) {},
              ayahKeyFor: (_) => GlobalKey(),
              onPlayAyah: onPlay,
            ),
          ),
        ));
    List<TapGestureRecognizer?> recognizers() {
      final rich = tester.widget<RichText>(find.byType(RichText).first);
      final out = <TapGestureRecognizer?>[];
      (rich.text as TextSpan).visitChildren((span) {
        if (span is TextSpan && (span.text ?? '').trim().isNotEmpty) {
          out.add(span.recognizer as TapGestureRecognizer?);
        }
        return true;
      });
      return out;
    }

    await pump((n) => played = n);
    recognizers()[1]!.onTap!();
    expect(played, 2);

    await pump(null);
    expect(recognizers().every((r) => r == null), isTrue);
  });
}
