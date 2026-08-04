// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled Tanzil assets, not a mock: the checksum
// constants must match the real files on disk, and parsing them must
// yield the well-known ayah counts. A regression here means either
// the asset changed without updating the checksum (import would then
// correctly refuse it) or the parser itself broke.

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_import_parser.dart';
import 'package:noor/features/quran/data/quran_import_service.dart';

void main() {
  late List<int> quranBytes;
  late List<int> metadataBytes;

  setUpAll(() {
    quranBytes = File(
      'assets/quran/tanzil-uthmani.txt',
    ).readAsBytesSync();
    metadataBytes = File(
      'assets/quran/tanzil-quran-data.xml',
    ).readAsBytesSync();
  });

  test('bundled Quran text matches the expected checksum', () {
    expect(
      sha256.convert(quranBytes).toString(),
      QuranImportService.expectedSha256,
    );
  });

  test('bundled surah metadata matches the expected checksum', () {
    expect(
      sha256.convert(metadataBytes).toString(),
      QuranImportService.expectedMetadataSha256,
    );
  });

  group('parseQuranImport', () {
    late QuranImportParsed parsed;

    setUpAll(() {
      parsed = parseQuranImport(
        QuranImportInput(quranBytes: quranBytes, metadataBytes: metadataBytes),
      );
    });

    test('yields all 114 surahs and 6236 ayahs', () {
      expect(parsed.surahRows, hasLength(114));
      expect(parsed.ayahRows, hasLength(6236));
    });

    test('known surah ayah counts match', () {
      int countFor(int surahId) =>
          parsed.ayahRows.where((r) => r['surah_id'] == surahId).length;

      expect(countFor(1), 7, reason: 'Al-Fatiha');
      expect(countFor(2), 286, reason: 'Al-Baqara');
      expect(countFor(114), 6, reason: 'An-Nas');
    });

    test('surah metadata carries Arabic name, translit, and place', () {
      final fatiha = parsed.surahRows.firstWhere((r) => r['id'] == 1);
      expect(fatiha['name_translit'], 'Al-Faatiha');
      expect(fatiha['name_english'], 'The Opening');
      expect(fatiha['ayah_count'], 7);
      expect(fatiha['name_arabic'], isNotEmpty);
      expect(fatiha['revelation_place'], anyOf('meccan', 'medinan'));
    });
  });
}
