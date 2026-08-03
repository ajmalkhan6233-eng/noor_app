// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reads a Tanzil-format Quran text file from assets, SHA-256 verifies
// it, and only then imports it into the database. No Quranic text is
// generated here — this only ever moves bytes the user supplies
// themselves from `assets/quran/` into SQLite, after verification.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/utils/arabic_text.dart';
import 'quran_import_status.dart';

class QuranImportService {
  QuranImportService({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  /// Path of the Tanzil "simple text" file the user supplies —
  /// `sura|aya|text` per line. TODO(user): add the real file here.
  static const assetPath = 'assets/quran/tanzil-simple.txt';

  /// TODO(user): replace with the real SHA-256 of the Tanzil file you
  /// add (e.g. `shasum -a 256 tanzil-simple.txt`). Left as an
  /// impossible value so import is refused until this is set for
  /// real — never trust an unverified file.
  static const expectedSha256 =
      'REPLACE_WITH_SHA256_OF_YOUR_TANZIL_FILE_0000000000000000000000000';

  /// Returns [QuranImported] if the database already holds a verified
  /// import; otherwise attempts one and returns the outcome.
  Future<QuranImportStatus> ensureImported() async {
    final db = await _dbHelper.database;
    final existing = await db.query('quran_import_meta', where: 'id = 1');
    if (existing.isNotEmpty) return const QuranImported();

    final ByteData bytes;
    try {
      bytes = await rootBundle.load(assetPath);
    } catch (_) {
      return const QuranAssetMissing();
    }

    final rawBytes = bytes.buffer.asUint8List();
    final digest = sha256.convert(rawBytes).toString();
    if (digest != expectedSha256) {
      return const QuranVerificationFailed();
    }

    final text = utf8.decode(rawBytes, allowMalformed: true);
    await _importTanzilText(db, text);
    await db.insert('quran_import_meta', {
      'id': 1,
      'imported_sha256': digest,
      'imported_at': DateTime.now().toIso8601String(),
    });
    return const QuranImported();
  }

  Future<void> _importTanzilText(Database db, String text) async {
    final ayahCountBySurah = <int, int>{};
    final batch = db.batch();

    for (final line in const LineSplitter().convert(text)) {
      final parts = line.split('|');
      if (parts.length != 3) continue;
      final surahId = int.tryParse(parts[0]);
      final ayahNumber = int.tryParse(parts[1]);
      if (surahId == null || ayahNumber == null) continue;
      final arabicText = parts[2];

      batch.insert('quran_ayahs', {
        'surah_id': surahId,
        'ayah_number': ayahNumber,
        'arabic_text': arabicText,
        'arabic_text_stripped': stripArabicDiacritics(arabicText),
      });
      ayahCountBySurah[surahId] = ayahNumber;
    }

    for (final entry in ayahCountBySurah.entries) {
      batch.insert('quran_surahs', {
        'id': entry.key,
        'ayah_count': entry.value,
      });
    }

    await batch.commit(noResult: true);
  }
}
