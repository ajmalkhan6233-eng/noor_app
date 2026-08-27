// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure data gathering/writing — no file I/O or encryption here (see
// backup_crypto.dart and backup_file_service.dart for those). Kept
// separate so the DB logic can be unit-tested against a plain
// in-memory database, same pattern as every other repository.

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database/database_helper.dart';
import 'backup_payload.dart';

class BackupRepository {
  BackupRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<BackupPayload> gather() async {
    final db = await _dbHelper.database;
    final prefs = await SharedPreferences.getInstance();

    final completions = await db.query('prayer_completions');
    final fasting = await db.query('fasting_days');
    final quranBookmarks = await db.query('quran_bookmarks');
    final azkarBookmarks = await db.rawQuery('''
      SELECT azkar_items.arabic_text, azkar_bookmarks.created_at
      FROM azkar_bookmarks
      JOIN azkar_items ON azkar_items.id = azkar_bookmarks.item_id
    ''');

    return BackupPayload(
      exportedAt: DateTime.now(),
      prayerCompletions: [
        for (final row in completions)
          PrayerCompletionEntry(date: row['date']! as String, prayer: row['prayer']! as String),
      ],
      fastingDays: [for (final row in fasting) row['date']! as String],
      quranBookmarks: [
        for (final row in quranBookmarks)
          QuranBookmarkEntry(
            surahId: row['surah_id']! as int,
            ayahNumber: row['ayah_number']! as int,
            createdAt: row['created_at']! as String,
          ),
      ],
      azkarBookmarks: [
        for (final row in azkarBookmarks)
          AzkarBookmarkEntry(
            arabicText: row['arabic_text']! as String,
            createdAt: row['created_at']! as String,
          ),
      ],
      zakatGoldPricePerGram: prefs.getDouble('zakat_last_gold_price_per_gram'),
      zakatSilverPricePerGram: prefs.getDouble('zakat_last_silver_price_per_gram'),
    );
  }

  /// Additive only — restoring a backup never deletes anything already
  /// on this device, it only adds what the backup has that's missing.
  /// A prayer/fasting day or bookmark already present is left alone
  /// (`ConflictAlgorithm.ignore`), so restoring twice, or restoring
  /// onto a device with its own newer history, can't lose data either
  /// way.
  Future<BackupRestoreResult> restore(BackupPayload payload) async {
    final db = await _dbHelper.database;
    final prefs = await SharedPreferences.getInstance();
    var azkarSkipped = 0;

    await db.transaction((txn) async {
      for (final e in payload.prayerCompletions) {
        await txn.insert(
          'prayer_completions',
          {'date': e.date, 'prayer': e.prayer},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      for (final date in payload.fastingDays) {
        await txn.insert(
          'fasting_days',
          {'date': date},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      for (final e in payload.quranBookmarks) {
        final existing = await txn.query(
          'quran_bookmarks',
          where: 'surah_id = ? AND ayah_number = ?',
          whereArgs: [e.surahId, e.ayahNumber],
          limit: 1,
        );
        if (existing.isNotEmpty) continue;
        await txn.insert('quran_bookmarks', {
          'surah_id': e.surahId,
          'ayah_number': e.ayahNumber,
          'created_at': e.createdAt,
        });
      }
      for (final e in payload.azkarBookmarks) {
        final item = await txn.query(
          'azkar_items',
          where: 'arabic_text = ?',
          whereArgs: [e.arabicText],
          limit: 1,
        );
        if (item.isEmpty) {
          azkarSkipped++;
          continue;
        }
        await txn.insert(
          'azkar_bookmarks',
          {'item_id': item.first['id'], 'created_at': e.createdAt},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });

    if (payload.zakatGoldPricePerGram != null) {
      await prefs.setDouble('zakat_last_gold_price_per_gram', payload.zakatGoldPricePerGram!);
    }
    if (payload.zakatSilverPricePerGram != null) {
      await prefs.setDouble(
        'zakat_last_silver_price_per_gram',
        payload.zakatSilverPricePerGram!,
      );
    }

    return BackupRestoreResult(azkarBookmarksSkipped: azkarSkipped);
  }
}

/// [azkarBookmarksSkipped] is normally 0 — only nonzero if the backup
/// came from a build whose Azkar dataset has since changed enough
/// that an item's text no longer matches anything on this device.
class BackupRestoreResult {
  const BackupRestoreResult({required this.azkarBookmarksSkipped});
  final int azkarBookmarksSkipped;
}
