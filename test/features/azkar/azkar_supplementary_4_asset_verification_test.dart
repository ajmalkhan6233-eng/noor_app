// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled funeral/weather/food_fasting/marriage
// dataset, not a mock: checksum must match the real file, every item
// must carry a non-empty source citation, and the per-category counts
// must match what was actually extracted from asellam/HisnElMuslim's
// hisn.json.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import_4.dart';

void main() {
  late List<int> bytes;
  late List<dynamic> items;

  setUpAll(() {
    bytes = File('assets/azkar/hisn-supplementary-4.json').readAsBytesSync();
    items = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
  });

  test('bundled supplementary-4 azkar dataset matches the expected checksum', () {
    expect(sha256.convert(bytes).toString(), azkarSupplementary4ExpectedSha256);
  });

  test('every item has a non-empty source citation and Arabic text', () {
    expect(items, isNotEmpty);
    for (final raw in items) {
      final item = raw as Map;
      expect(item['source'], isNotEmpty);
      expect(item['content'], isNotEmpty);
      expect(
        ['funeral', 'weather', 'food_fasting', 'marriage'],
        contains(item['category']),
      );
    }
  });

  test('per-category counts match the extracted chapters', () {
    final byCategory = <String, int>{};
    for (final raw in items) {
      final category = (raw as Map)['category'] as String;
      byCategory[category] = (byCategory[category] ?? 0) + 1;
    }
    expect(byCategory['funeral'], 14);
    expect(byCategory['weather'], 9);
    expect(byCategory['food_fasting'], 12);
    expect(byCategory['marriage'], 3);
  });
}
