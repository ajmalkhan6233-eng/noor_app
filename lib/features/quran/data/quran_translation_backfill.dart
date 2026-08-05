// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of QuranImportService to keep that file under the
// project's line-count convention. Backfills the English translation
// into already-imported ayah rows — separately checksummed from the
// Arabic import so a missing or unverified translation asset never
// blocks the Arabic-only reading experience that already works today.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../core/database/schema/quran_schema.dart';
import 'quran_import_parser.dart';

/// SHA-256 of the exact bytes in [quranTranslationAssetPath] — see
/// `assets/quran_translations/README.md` for provenance and
/// verification.
const quranTranslationExpectedSha256 =
    'a98e1f2f7cdd728501c73750c6f3caf3fa3e80216b1520a1d7cd7ae8cec35d94';

const quranTranslationAssetPath = 'assets/quran_translations/en-sahih.txt';

const _batchSize = 500;

/// Runs once per database: if the translation hasn't been imported yet
/// and the bundled asset verifies, updates every matching ayah row's
/// `translation` column. No-ops silently on a missing or mismatched
/// asset — the Arabic text stays fully usable either way.
Future<void> ensureQuranTranslationImported(Database db) async {
  // Self-creating rather than relying on DatabaseHelper's onCreate/
  // onUpgrade: this keeps the translation feature a self-contained
  // addition that works against any existing `quran_ayahs` table,
  // regardless of which schema version created it.
  await db.execute(quranTranslationImportMetaCreateStatement);
  final existing = await db.query('quran_translation_import_meta', where: 'id = 1');
  if (existing.isNotEmpty) return;

  final ByteData translationData;
  try {
    translationData = await rootBundle.load(quranTranslationAssetPath);
  } catch (_) {
    return;
  }

  final translationBytes = translationData.buffer.asUint8List();
  final translationDigest = sha256.convert(translationBytes).toString();
  if (translationDigest != quranTranslationExpectedSha256) return;

  final rows = await compute(parseQuranTranslation, translationBytes);
  for (var start = 0; start < rows.length; start += _batchSize) {
    final end = (start + _batchSize).clamp(0, rows.length);
    final batch = db.batch();
    for (final row in rows.sublist(start, end)) {
      batch.update(
        'quran_ayahs',
        {'translation': row.text},
        where: 'surah_id = ? AND ayah_number = ?',
        whereArgs: [row.surahId, row.ayahNumber],
      );
    }
    await batch.commit(noResult: true);
  }

  await db.insert('quran_translation_import_meta', {
    'id': 1,
    'imported_sha256': translationDigest,
    'imported_at': DateTime.now().toIso8601String(),
  });
}
