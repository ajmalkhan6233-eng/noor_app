// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled azkar dataset, not a mock: checksums
// must match the real files, every item must carry a non-empty
// source citation, and the morning/evening split must match the
// dataset's own type markers.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_import_service.dart';

void main() {
  late List<int> arBytes;
  late List<int> enBytes;

  setUpAll(() {
    arBytes = File('assets/azkar/adhkar-ar.json').readAsBytesSync();
    enBytes = File('assets/azkar/adhkar-en.json').readAsBytesSync();
  });

  test('bundled Arabic azkar dataset matches the expected checksum', () {
    expect(
      sha256.convert(arBytes).toString(),
      AzkarImportService.expectedArSha256,
    );
  });

  test('bundled English azkar dataset matches the expected checksum', () {
    expect(
      sha256.convert(enBytes).toString(),
      AzkarImportService.expectedEnSha256,
    );
  });

  test('every item has a non-empty source citation and Arabic text', () {
    final items = jsonDecode(utf8.decode(arBytes)) as List<dynamic>;
    expect(items, isNotEmpty);
    for (final raw in items) {
      final item = raw as Map;
      expect(item['source'], isNotEmpty);
      expect(item['content'], isNotEmpty);
    }
  });

  test('morning/evening split matches the dataset\'s type markers', () {
    final items = jsonDecode(utf8.decode(arBytes)) as List<dynamic>;
    final byType = <int, int>{};
    for (final raw in items) {
      final type = (raw as Map)['type'] as int;
      byType[type] = (byType[type] ?? 0) + 1;
    }
    // type 0 = both, 1 = morning-only, 2 = evening-only.
    expect(byType[0], 16);
    expect(byType[1], 10);
    expect(byType[2], 8);
  });
}
