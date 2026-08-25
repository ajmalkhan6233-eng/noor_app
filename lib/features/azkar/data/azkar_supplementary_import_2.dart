// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Backfills five more azkar categories — child_protection, illness,
// distress, debt, visiting_grave — added 2026-08-25 in response to a
// direct request to expand dua coverage beyond morning/evening. Same
// source and licence as azkar_supplementary_import.dart
// (asellam/HisnElMuslim, MIT), same pattern: self-contained, its own
// checksum, never blocks anything else if the asset is missing or
// fails verification. See assets/azkar/README.md's provenance section
// for exactly which of that repo's 133 chapters each category came
// from and how the extraction was done (direct JSON field copy from
// the downloaded source file, never hand-typed).

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const azkarSupplementary2AssetPath = 'assets/azkar/hisn-supplementary-2.json';

/// SHA-256 of the exact bytes in [azkarSupplementary2AssetPath].
const azkarSupplementary2ExpectedSha256 =
    'fbd0674bfbce9cde4fa09819c3224307c5b36439837dadeeed4b4df95632c47f';

Future<void> ensureAzkarSupplementary2Imported(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS azkar_supplementary_2_import_meta (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      imported_sha256 TEXT NOT NULL,
      imported_at TEXT NOT NULL
    )
  ''');
  final existing = await db.query('azkar_supplementary_2_import_meta', where: 'id = 1');
  if (existing.isNotEmpty) return;

  final ByteData data;
  try {
    data = await rootBundle.load(azkarSupplementary2AssetPath);
  } catch (_) {
    return;
  }

  final bytes = data.buffer.asUint8List();
  final digest = sha256.convert(bytes).toString();
  if (digest != azkarSupplementary2ExpectedSha256) return;

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

  await db.insert('azkar_supplementary_2_import_meta', {
    'id': 1,
    'imported_sha256': digest,
    'imported_at': DateTime.now().toIso8601String(),
  });
}
