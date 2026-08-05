// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled after_prayer/sleep/travel dataset, not
// a mock: checksum must match the real file, every item must carry a
// non-empty source citation, and the per-category counts must match
// what was actually extracted from asellam/HisnElMuslim's hisn.json.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import.dart';

void main() {
  late List<int> bytes;
  late List<dynamic> items;

  setUpAll(() {
    bytes = File('assets/azkar/hisn-supplementary.json').readAsBytesSync();
    items = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
  });

  test('bundled supplementary azkar dataset matches the expected checksum', () {
    expect(sha256.convert(bytes).toString(), azkarSupplementaryExpectedSha256);
  });

  test('every item has a non-empty source citation and Arabic text', () {
    expect(items, isNotEmpty);
    for (final raw in items) {
      final item = raw as Map;
      expect(item['source'], isNotEmpty);
      expect(item['content'], isNotEmpty);
      expect(['after_prayer', 'sleep', 'travel'], contains(item['category']));
    }
  });

  test('per-category counts match the extracted chapters', () {
    final byCategory = <String, int>{};
    for (final raw in items) {
      final category = (raw as Map)['category'] as String;
      byCategory[category] = (byCategory[category] ?? 0) + 1;
    }
    expect(byCategory['after_prayer'], 8);
    expect(byCategory['sleep'], 15);
    expect(byCategory['travel'], 1);
  });
}
