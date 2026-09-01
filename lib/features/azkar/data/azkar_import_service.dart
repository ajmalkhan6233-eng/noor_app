// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reads the bundled MIT-licensed azkar dataset, SHA-256 verifies both
// files, and only then imports them into the database. See
// `assets/azkar/README.md` for full provenance. No azkar text is ever
// generated here, and every imported item carries its dataset's own
// `source` citation — there is no path that displays unverified or
// unattributed text.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../core/database/database_helper.dart';
import 'azkar_import_status.dart';
import 'azkar_supplementary_import.dart';
import 'azkar_supplementary_import_2.dart';
import 'azkar_supplementary_import_3.dart';
import 'azkar_supplementary_import_4.dart';

class AzkarImportService {
  AzkarImportService({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  static const arAssetPath = 'assets/azkar/adhkar-ar.json';
  static const enAssetPath = 'assets/azkar/adhkar-en.json';

  /// See `assets/azkar/README.md` for how these were sourced/verified.
  static const expectedArSha256 =
      '9e0dd6a10d26ddc0e2b36b94098c287644996c7f81b707f8ad24f1ce40b8c821';
  static const expectedEnSha256 =
      'eec053c4138bed6f3ec7dc3c0e06e926a935dca24663788e5b97a0bfb5f71896';

  Future<AzkarImportStatus> ensureImported() async {
    final db = await _dbHelper.database;
    final existing = await db.query('azkar_import_meta', where: 'id = 1');
    if (existing.isNotEmpty) {
      await ensureAzkarSupplementaryImported(db);
      await ensureAzkarSupplementary2Imported(db);
      await ensureAzkarSupplementary3Imported(db);
      await ensureAzkarSupplementary4Imported(db);
      return const AzkarImported();
    }

    final ByteData arData;
    final ByteData enData;
    try {
      arData = await rootBundle.load(arAssetPath);
      enData = await rootBundle.load(enAssetPath);
    } catch (_) {
      return const AzkarAssetMissing();
    }

    final arBytes = arData.buffer.asUint8List();
    final enBytes = enData.buffer.asUint8List();
    final arDigest = sha256.convert(arBytes).toString();
    final enDigest = sha256.convert(enBytes).toString();
    if (arDigest != expectedArSha256 || enDigest != expectedEnSha256) {
      return const AzkarVerificationFailed();
    }

    final arItems = jsonDecode(utf8.decode(arBytes)) as List<dynamic>;
    final enItems = jsonDecode(utf8.decode(enBytes)) as List<dynamic>;
    final enByOrder = <int, Map>{
      for (final item in enItems) (item as Map)['order'] as int: item,
    };

    final categoryIds = await _categoryIds(db);
    final batch = db.batch();
    var order = {'morning': 0, 'evening': 0};
    for (final raw in arItems) {
      final ar = raw as Map;
      final en = enByOrder[ar['order'] as int];
      final type = ar['type'] as int;
      for (final key in _categoriesForType(type)) {
        batch.insert('azkar_items', {
          'category_id': categoryIds[key],
          'arabic_text': ar['content'] as String,
          'transliteration': en?['transliteration'] as String?,
          'translation': en?['translation'] as String?,
          'repeat_count': ar['count'] as int? ?? 1,
          'source': ar['source'] as String,
          'display_order': order[key] = (order[key] ?? 0) + 1,
        });
      }
    }
    await batch.commit(noResult: true);

    await db.insert('azkar_import_meta', {
      'id': 1,
      'imported_ar_sha256': arDigest,
      'imported_en_sha256': enDigest,
      'imported_at': DateTime.now().toIso8601String(),
    });
    await ensureAzkarSupplementaryImported(db);
    await ensureAzkarSupplementary2Imported(db);
    await ensureAzkarSupplementary3Imported(db);
    await ensureAzkarSupplementary4Imported(db);
    return const AzkarImported();
  }

  /// type 0 = both morning and evening, 1 = morning only, 2 = evening.
  List<String> _categoriesForType(int type) => switch (type) {
    1 => const ['morning'],
    2 => const ['evening'],
    _ => const ['morning', 'evening'],
  };

  Future<Map<String, int>> _categoryIds(Database db) async {
    final rows = await db.query('azkar_categories');
    return {
      for (final row in rows)
        row['category_key']! as String: row['id']! as int,
    };
  }
}
