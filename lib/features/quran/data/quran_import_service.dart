// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reads the bundled Tanzil text + surah-metadata assets, SHA-256
// verifies both, and only then imports them into the database. No
// Quranic text is ever generated here — this only ever moves bytes
// shipped in `assets/quran/` (see the README there for provenance)
// into SQLite, after verification. Parsing runs on a background
// isolate; there is no path that displays unverified text.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../core/database/database_helper.dart';
import 'quran_import_parser.dart';
import 'quran_import_status.dart';
import 'quran_translation_backfill.dart';

class QuranImportService {
  QuranImportService({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  static const assetPath = 'assets/quran/tanzil-uthmani.txt';
  static const metadataAssetPath = 'assets/quran/tanzil-quran-data.xml';

  /// SHA-256 of the exact bytes in [assetPath] — see
  /// `assets/quran/README.md` for how this file was sourced and
  /// verified. Import is refused if the bundled asset doesn't match.
  static const expectedSha256 =
      '8119475acf1ddd48a242f663dce7a21f0a8514e901bba136d4156805b766ece5';

  /// SHA-256 of the exact bytes in [metadataAssetPath].
  static const expectedMetadataSha256 =
      '8867c1d88191472adec9db694b3cd9f135b1a2ef580574d32cf888dcb22c5c7a';

  static const _batchSize = 500;

  /// Returns [QuranImported] if the database already holds a verified
  /// import; otherwise attempts one, reporting 0..1 via [onProgress]
  /// as it goes, and returns the outcome.
  Future<QuranImportStatus> ensureImported({
    void Function(double progress)? onProgress,
  }) async {
    final db = await _dbHelper.database;
    final existing = await db.query('quran_import_meta', where: 'id = 1');
    if (existing.isNotEmpty) {
      await ensureQuranTranslationImported(db);
      return const QuranImported();
    }

    final ByteData quranData;
    final ByteData metadataData;
    try {
      quranData = await rootBundle.load(assetPath);
      metadataData = await rootBundle.load(metadataAssetPath);
    } catch (_) {
      return const QuranAssetMissing();
    }

    final quranBytes = quranData.buffer.asUint8List();
    final metadataBytes = metadataData.buffer.asUint8List();
    final quranDigest = sha256.convert(quranBytes).toString();
    final metadataDigest = sha256.convert(metadataBytes).toString();
    if (quranDigest != expectedSha256 ||
        metadataDigest != expectedMetadataSha256) {
      return const QuranVerificationFailed();
    }

    final parsed = await compute(
      parseQuranImport,
      QuranImportInput(quranBytes: quranBytes, metadataBytes: metadataBytes),
    );

    await _insertInBatches(db, 'quran_surahs', parsed.surahRows);
    onProgress?.call(0.1);
    await _insertInBatches(
      db,
      'quran_ayahs',
      parsed.ayahRows,
      onProgress: (fraction) => onProgress?.call(0.1 + fraction * 0.9),
    );

    await db.insert('quran_import_meta', {
      'id': 1,
      'imported_sha256': quranDigest,
      'imported_metadata_sha256': metadataDigest,
      'imported_at': DateTime.now().toIso8601String(),
    });
    onProgress?.call(1);
    await ensureQuranTranslationImported(db);
    return const QuranImported();
  }

  Future<void> _insertInBatches(
    Database db,
    String table,
    List<Map<String, Object?>> rows, {
    void Function(double fraction)? onProgress,
  }) async {
    for (var start = 0; start < rows.length; start += _batchSize) {
      final end = (start + _batchSize).clamp(0, rows.length);
      final batch = db.batch();
      for (final row in rows.sublist(start, end)) {
        batch.insert(table, row);
      }
      await batch.commit(noResult: true);
      onProgress?.call(end / rows.length);
    }
  }
}
