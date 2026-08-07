// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Verifies the actual bundled Tawaf/Sa'i dua asset, not a mock.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/pilgrimage/data/pilgrimage_dua_repository.dart';

void main() {
  late List<int> bytes;
  late List<dynamic> entries;

  setUpAll(() {
    bytes = File('assets/pilgrimage/hisn-tawaf-sai.json').readAsBytesSync();
    entries = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
  });

  test('bundled dua asset matches the expected checksum', () {
    expect(sha256.convert(bytes).toString(), PilgrimageDuaRepository.expectedSha256);
  });

  test('has exactly the tawaf and sai keys, each with content and a source', () {
    final keys = entries.map((e) => (e as Map)['key']).toSet();
    expect(keys, {'tawaf', 'sai'});
    for (final raw in entries) {
      final entry = raw as Map;
      expect(entry['content'], isNotEmpty);
      expect(entry['source'], isNotEmpty);
      expect(entry['count'], isA<int>());
    }
  });

  test('sai dhikr is recited three times, tawaf dua once per circuit', () {
    final byKey = {for (final raw in entries) (raw as Map)['key']: raw};
    expect(byKey['sai']!['count'], 3);
    expect(byKey['tawaf']!['count'], 1);
  });
}
