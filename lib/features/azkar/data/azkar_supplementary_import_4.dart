// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Backfills four more azkar categories — funeral, weather,
// food_fasting, marriage — closing real gaps this app's own README
// had already flagged as missing from Hisn al-Muslim's standard
// coverage. Same source and licence as the earlier supplementary
// imports (asellam/HisnElMuslim, MIT, re-downloaded fresh and
// re-verified this session), same pattern: self-contained, its own
// checksum, never blocks anything else if the asset is missing or
// fails verification. See assets/azkar/README.md's provenance section
// for exactly which of that repo's 133 chapters each category came
// from and how the extraction was done (direct JSON field copy from
// the downloaded source file, never hand-typed).

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const azkarSupplementary4AssetPath = 'assets/azkar/hisn-supplementary-4.json';

/// SHA-256 of the exact bytes in [azkarSupplementary4AssetPath].
const azkarSupplementary4ExpectedSha256 =
    'd34174c694cda975660f83b1dcb2f70767ebf4230779edacfd2257e733444164';

Future<void> ensureAzkarSupplementary4Imported(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS azkar_supplementary_4_import_meta (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      imported_sha256 TEXT NOT NULL,
      imported_at TEXT NOT NULL
    )
  ''');
  final existing = await db.query('azkar_supplementary_4_import_meta', where: 'id = 1');
  if (existing.isNotEmpty) return;

  final ByteData data;
  try {
    data = await rootBundle.load(azkarSupplementary4AssetPath);
  } catch (_) {
    return;
  }

  final bytes = data.buffer.asUint8List();
  final digest = sha256.convert(bytes).toString();
  if (digest != azkarSupplementary4ExpectedSha256) return;

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

  await db.insert('azkar_supplementary_4_import_meta', {
    'id': 1,
    'imported_sha256': digest,
    'imported_at': DateTime.now().toIso8601String(),
  });
}
