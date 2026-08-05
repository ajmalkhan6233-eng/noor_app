// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Backfills the after_prayer/sleep/travel azkar categories, which the
// main morning/evening dataset (Seen-Arabic/Morning-And-Evening-Adhkar-DB)
// never covered. Self-contained and separately checksummed from
// AzkarImportService — see assets/azkar/README.md for provenance —
// so it works regardless of when the main import ran, and a missing
// or unverified asset never blocks the morning/evening azkar that
// already work today.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const azkarSupplementaryAssetPath = 'assets/azkar/hisn-supplementary.json';

/// SHA-256 of the exact bytes in [azkarSupplementaryAssetPath].
const azkarSupplementaryExpectedSha256 =
    '0f683306e391af8a80c09457a620bd29ef56b7e5c973ebf4339bc30321b335c3';

Future<void> ensureAzkarSupplementaryImported(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS azkar_supplementary_import_meta (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      imported_sha256 TEXT NOT NULL,
      imported_at TEXT NOT NULL
    )
  ''');
  final existing = await db.query('azkar_supplementary_import_meta', where: 'id = 1');
  if (existing.isNotEmpty) return;

  final ByteData data;
  try {
    data = await rootBundle.load(azkarSupplementaryAssetPath);
  } catch (_) {
    return;
  }

  final bytes = data.buffer.asUint8List();
  final digest = sha256.convert(bytes).toString();
  if (digest != azkarSupplementaryExpectedSha256) return;

  final items = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
  final categoryIds = {
    for (final row in await db.query('azkar_categories'))
      row['category_key']! as String: row['id']! as int,
  };

  final order = <String, int>{};
  final batch = db.batch();
  for (final raw in items) {
    final item = raw as Map;
    final category = item['category'] as String;
    final categoryId = categoryIds[category];
    if (categoryId == null) continue;
    batch.insert('azkar_items', {
      'category_id': categoryId,
      'arabic_text': item['content'] as String,
      'repeat_count': item['count'] as int? ?? 1,
      'source': item['source'] as String,
      'display_order': order[category] = (order[category] ?? 0) + 1,
    });
  }
  await batch.commit(noResult: true);

  await db.insert('azkar_supplementary_import_meta', {
    'id': 1,
    'imported_sha256': digest,
    'imported_at': DateTime.now().toIso8601String(),
  });
}
