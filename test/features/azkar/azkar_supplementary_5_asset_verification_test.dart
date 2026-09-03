// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled waking_up/home/clothing/toilet/wudu/
// mosque/anger/fear/sneezing dataset, not a mock: checksum must match
// the real file, every item must carry a non-empty source citation,
// and the per-category counts must match what was actually extracted
// from asellam/HisnElMuslim's hisn.json.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import_5.dart';

const _categories = [
  'waking_up',
  'home',
  'clothing',
  'toilet',
  'wudu',
  'mosque',
  'anger',
  'fear',
  'sneezing',
];

void main() {
  late List<int> bytes;
  late List<dynamic> items;

  setUpAll(() {
    bytes = File('assets/azkar/hisn-supplementary-5.json').readAsBytesSync();
    items = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
  });

  test('bundled supplementary-5 azkar dataset matches the expected checksum', () {
    expect(sha256.convert(bytes).toString(), azkarSupplementary5ExpectedSha256);
  });

  test('every item has a non-empty source citation and Arabic text', () {
    expect(items, isNotEmpty);
    for (final raw in items) {
      final item = raw as Map;
      expect(item['source'], isNotEmpty);
      expect(item['content'], isNotEmpty);
      expect(_categories, contains(item['category']));
    }
  });

  test('per-category counts match the extracted chapters', () {
    final byCategory = <String, int>{};
    for (final raw in items) {
      final category = (raw as Map)['category'] as String;
      byCategory[category] = (byCategory[category] ?? 0) + 1;
    }
    expect(byCategory['waking_up'], 4);
    expect(byCategory['home'], 3);
    expect(byCategory['clothing'], 5);
    expect(byCategory['toilet'], 2);
    expect(byCategory['wudu'], 4);
    expect(byCategory['mosque'], 12);
    expect(byCategory['anger'], 1);
    expect(byCategory['fear'], 3);
    expect(byCategory['sneezing'], 2);
  });

  test('total item count is 36', () {
    expect(items.length, 36);
  });
}
