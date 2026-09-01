// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The full Hisnul Muslim book (267 duas, Sa'id bin Ali bin Wahf
// Al-Qahtani), 2026-09-01, direct approval ("download hundred to two
// hundred dua... make it easier to find"). Sourced from
// github.com/wafaaelmaandy/Hisn-Muslim-Json (husn_en.json), itself the
// same hisnmuslim.com data behind the official Hisnul Muslim app —
// verified live: clean encoding, no corruption, Arabic/translation
// pairs spot-checked against known duas.
//
// Deduped against the earlier partial imports (hisn-supplementary.json
// through -3.json) by Arabic text with diacritics/punctuation/alif
// variants stripped first — the two sources transcribe the same duas
// with different tashkeel and parenthesisation, so an exact-string
// compare alone missed real duplicates (confirmed live: "visiting the
// sick" and "debt" chapters both had lines that matched only after
// normalising). 223 of the book's 267 duas are net new; the rest were
// already present. The one chapter skipped entirely rather than
// mapped in ("Words of remembrance for morning and evening") is
// already covered by the separate, curated morning/evening dataset
// from a different source — including it risked visible duplicate
// azkar on the two screens the user already uses daily.
//
// Split into nine new categories (see azkar_category.dart) rather than
// folded entirely into the existing eleven, since most of the book's
// 132 chapters (ablution, during-prayer postures, Hajj/Umrah, weather,
// eating, daily manners, etc.) don't fit any of them.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const azkarSupplementary4AssetPath = 'assets/azkar/hisn-supplementary-4.json';

/// SHA-256 of the exact bytes in [azkarSupplementary4AssetPath].
const azkarSupplementary4ExpectedSha256 =
    '4cf2203909a4b1dc072fbf111d8580aaa5ab242831f5efa8d40c990263867e54';

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
      'transliteration': item['transliteration'] as String?,
      'translation': item['translation'] as String?,
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
