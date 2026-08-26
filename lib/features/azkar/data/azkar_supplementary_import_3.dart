// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Splits "Visiting the Sick" out into its own category (2026-08-26,
// direct request: distinct from general `illness`). Same source and
// licence as the other supplementary imports (asellam/HisnElMuslim,
// MIT), re-downloaded fresh and re-verified this same session — see
// assets/azkar/README.md's provenance section.
//
// The two duas actually said *for* a sick person being visited
// ("الدُّعَاءُ لِلْمَرِيضِ فِي عِيَادَتِهِ") were originally folded
// into `illness` alongside the unrelated "despaired of life" dua
// (azkar_supplementary_import_2.dart), because `illness` was the only
// category that existed at the time. Existing installs already have
// those two rows imported under `illness` — this file moves them
// (matched by `arabic_text` read from this file's own bundled JSON at
// import time, never by row id, since ids aren't stable across
// installs, and never by a hand-typed string constant, to avoid a
// transcription mismatch against what's actually in those rows)
// rather than leaving a duplicate behind, then adds the "virtue of
// visiting the sick" hadith
// (a third, previously-unincluded chapter) alongside them. Fresh
// installs reach the same end state: illness's own import runs first
// (same call order in AzkarImportService), so the two rows always
// exist to be moved by the time this file runs.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const azkarSupplementary3AssetPath = 'assets/azkar/hisn-supplementary-3.json';

/// SHA-256 of the exact bytes in [azkarSupplementary3AssetPath].
const azkarSupplementary3ExpectedSha256 =
    '457a887f2da5da4d32e8dee7d28cdad132038f740b031976262bdeec2c290ea8';

/// How many of [azkarSupplementary3AssetPath]'s leading entries are
/// the duplicates moving out of `illness` (chapter order in the JSON
/// puts them first) rather than new content, like the virtue-of-
/// visiting item, that only ever belonged here. The match texts
/// themselves are read from the asset at import time, not retyped
/// into this file, so there's no risk of a transcription mismatch
/// against what's actually sitting in the `illness` rows.
const _movedFromIllnessCount = 2;

Future<void> ensureAzkarSupplementary3Imported(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS azkar_supplementary_3_import_meta (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      imported_sha256 TEXT NOT NULL,
      imported_at TEXT NOT NULL
    )
  ''');
  final existing = await db.query('azkar_supplementary_3_import_meta', where: 'id = 1');
  if (existing.isNotEmpty) return;

  final ByteData data;
  try {
    data = await rootBundle.load(azkarSupplementary3AssetPath);
  } catch (_) {
    return;
  }

  final bytes = data.buffer.asUint8List();
  final digest = sha256.convert(bytes).toString();
  if (digest != azkarSupplementary3ExpectedSha256) return;

  final items = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
  final categoryIds = {
    for (final row in await db.query('azkar_categories'))
      row['category_key']! as String: row['id']! as int,
  };
  final illnessId = categoryIds['illness'];
  final visitingSickId = categoryIds['visiting_sick'];
  if (illnessId == null || visitingSickId == null) return;

  final movedFromIllness = items
      .take(_movedFromIllnessCount)
      .map((raw) => (raw as Map)['content'] as String)
      .toList();
  if (movedFromIllness.isNotEmpty) {
    await db.delete(
      'azkar_items',
      where: 'category_id = ? AND arabic_text IN (${movedFromIllness.map((_) => '?').join(', ')})',
      whereArgs: [illnessId, ...movedFromIllness],
    );
  }

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

  await db.insert('azkar_supplementary_3_import_meta', {
    'id': 1,
    'imported_sha256': digest,
    'imported_at': DateTime.now().toIso8601String(),
  });
}
