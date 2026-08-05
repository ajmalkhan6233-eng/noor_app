// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled translation asset, not a mock — same
// discipline as quran_asset_verification_test.dart for the Arabic
// text. A regression here means either the asset changed without
// updating the checksum (the backfill would then correctly skip it)
// or the parser itself broke.

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_import_parser.dart';
import 'package:noor/features/quran/data/quran_translation_backfill.dart';

void main() {
  late List<int> translationBytes;

  setUpAll(() {
    translationBytes = File(
      'assets/quran_translations/en-sahih.txt',
    ).readAsBytesSync();
  });

  test('bundled translation text matches the expected checksum', () {
    expect(
      sha256.convert(translationBytes).toString(),
      quranTranslationExpectedSha256,
    );
  });

  group('parseQuranTranslation', () {
    late List<QuranTranslationRow> rows;

    setUpAll(() {
      rows = parseQuranTranslation(translationBytes);
    });

    test('yields all 6236 ayahs', () {
      expect(rows, hasLength(6236));
    });

    test('known surah ayah counts match', () {
      int countFor(int surahId) => rows.where((r) => r.surahId == surahId).length;

      expect(countFor(1), 7, reason: 'Al-Fatiha');
      expect(countFor(2), 286, reason: 'Al-Baqara');
      expect(countFor(114), 6, reason: 'An-Nas');
    });

    test('first ayah text matches the well-known Saheeh International wording', () {
      final firstAyah = rows.firstWhere((r) => r.surahId == 1 && r.ayahNumber == 1);
      expect(
        firstAyah.text,
        'In the name of Allah, the Entirely Merciful, the Especially Merciful',
      );
    });

    test('no duplicate or missing (surah, ayah) keys', () {
      final keys = rows.map((r) => (r.surahId, r.ayahNumber)).toSet();
      expect(keys, hasLength(rows.length));
    });
  });
}
