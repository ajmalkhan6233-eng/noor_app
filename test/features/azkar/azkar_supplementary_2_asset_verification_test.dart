// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled child_protection/illness/distress/debt/
// visiting_grave dataset, not a mock: checksum must match the real
// file, every item must carry a non-empty source citation, and the
// per-category counts must match what was actually extracted from
// asellam/HisnElMuslim's hisn.json.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_supplementary_import_2.dart';

void main() {
  late List<int> bytes;
  late List<dynamic> items;

  setUpAll(() {
    bytes = File('assets/azkar/hisn-supplementary-2.json').readAsBytesSync();
    items = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
  });

  test('bundled supplementary-2 azkar dataset matches the expected checksum', () {
    expect(sha256.convert(bytes).toString(), azkarSupplementary2ExpectedSha256);
  });

  test('every item has a non-empty source citation and Arabic text', () {
    expect(items, isNotEmpty);
    for (final raw in items) {
      final item = raw as Map;
      expect(item['source'], isNotEmpty);
      expect(item['content'], isNotEmpty);
      expect(
        ['child_protection', 'illness', 'distress', 'debt', 'visiting_grave'],
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
    expect(byCategory['child_protection'], 1);
    expect(byCategory['illness'], 5);
    expect(byCategory['distress'], 6);
    expect(byCategory['debt'], 2);
    expect(byCategory['visiting_grave'], 1);
  });
}
