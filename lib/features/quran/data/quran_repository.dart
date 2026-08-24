// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file (plus QuranImportService) touches the `quran_*`
// tables — every row it can return came from a SHA-256-verified
// import; this repository never generates text of its own.

import '../../../core/database/database_helper.dart';
import '../../../core/utils/arabic_text.dart';
import 'quran_ayah.dart';
import 'quran_bookmark.dart';
import 'quran_surah.dart';

class QuranRepository {
  QuranRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<List<QuranSurah>> surahs() async {
    final db = await _dbHelper.database;
    final rows = await db.query('quran_surahs', orderBy: 'id ASC');
    return [for (final row in rows) _toSurah(row)];
  }

  QuranSurah _toSurah(Map<String, Object?> row) {
    final place = row['revelation_place'] as String?;
    return QuranSurah(
      id: row['id']! as int,
      ayahCount: row['ayah_count']! as int,
      nameArabic: row['name_arabic'] as String?,
      nameTranslit: row['name_translit'] as String?,
      nameEnglish: row['name_english'] as String?,
      revelationPlace: switch (place) {
        'meccan' => RevelationPlace.meccan,
        'medinan' => RevelationPlace.medinan,
        _ => null,
      },
    );
  }

  /// Every ayah in the whole Quran, in canonical order — backs the
  /// continuous full-Quran reading view. ~6,236 rows of short text;
  /// loading it all up front is well within a phone's memory budget,
  /// and simpler/more reliable than paging across surah boundaries.
  Future<List<QuranAyah>> allAyahs() async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'quran_ayahs',
      orderBy: 'surah_id ASC, ayah_number ASC',
    );
    return _toAyahs(rows);
  }

  Future<List<QuranAyah>> ayahsForSurah(int surahId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'quran_ayahs',
      where: 'surah_id = ?',
      whereArgs: [surahId],
      orderBy: 'ayah_number ASC',
    );
    return _toAyahs(rows);
  }

  /// Diacritic-insensitive search over the Arabic text.
  Future<List<QuranAyah>> search(String query) async {
    final stripped = stripArabicDiacritics(query).trim();
    if (stripped.isEmpty) return [];

    final db = await _dbHelper.database;
    final rows = await db.query(
      'quran_ayahs',
      where: 'arabic_text_stripped LIKE ?',
      whereArgs: ['%$stripped%'],
      orderBy: 'surah_id ASC, ayah_number ASC',
      limit: 200,
    );
    return _toAyahs(rows);
  }

  List<QuranAyah> _toAyahs(List<Map<String, Object?>> rows) => [
    for (final row in rows)
      QuranAyah(
        surahId: row['surah_id']! as int,
        ayahNumber: row['ayah_number']! as int,
        arabicText: row['arabic_text']! as String,
        translation: row['translation'] as String?,
      ),
  ];

  Future<List<QuranBookmark>> bookmarks() async {
    final db = await _dbHelper.database;
    final rows = await db.query('quran_bookmarks', orderBy: 'id DESC');
    return [
      for (final row in rows)
        QuranBookmark(
          id: row['id']! as int,
          surahId: row['surah_id']! as int,
          ayahNumber: row['ayah_number']! as int,
        ),
    ];
  }

  Future<void> addBookmark(int surahId, int ayahNumber) async {
    final db = await _dbHelper.database;
    await db.insert('quran_bookmarks', {
      'surah_id': surahId,
      'ayah_number': ayahNumber,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeBookmark(int bookmarkId) async {
    final db = await _dbHelper.database;
    await db.delete('quran_bookmarks', where: 'id = ?', whereArgs: [bookmarkId]);
  }

  /// Looks up one specific ayah by (surah, ayah) — e.g. for a guide
  /// screen that wants to quote a single verse. Returns `null` if the
  /// Quran hasn't been imported yet (table empty) or the reference
  /// doesn't exist; callers must show their own "not loaded" state,
  /// never invented text.
  Future<QuranAyah?> singleAyah(int surahId, int ayahNumber) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'quran_ayahs',
      where: 'surah_id = ? AND ayah_number = ?',
      whereArgs: [surahId, ayahNumber],
    );
    if (rows.isEmpty) return null;
    return _toAyahs(rows).first;
  }

  /// Deterministic "ayah of the day": the same verse for everyone on
  /// a given calendar day, picked only from rows that already carry a
  /// verified translation (never a blind pick that might land on an
  /// Arabic-only row with no translation to show). Returns `null` if
  /// the Quran hasn't been imported yet — callers must show their own
  /// "not loaded" state, never invented text.
  Future<QuranAyah?> ayahOfTheDay({DateTime? date}) async {
    final db = await _dbHelper.database;
    final countRows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM quran_ayahs WHERE translation IS NOT NULL',
    );
    final total = countRows.first['c'] as int? ?? 0;
    if (total == 0) return null;

    final day = date ?? DateTime.now();
    final dayOfYear = day.difference(DateTime(day.year, 1, 1)).inDays;
    final offset = (day.year * 1000 + dayOfYear) % total;

    final rows = await db.query(
      'quran_ayahs',
      where: 'translation IS NOT NULL',
      orderBy: 'surah_id ASC, ayah_number ASC',
      limit: 1,
      offset: offset,
    );
    if (rows.isEmpty) return null;
    return _toAyahs(rows).first;
  }

  Future<QuranReadingPosition?> lastRead() async {
    final db = await _dbHelper.database;
    final rows = await db.query('quran_last_read', where: 'id = 1');
    if (rows.isEmpty) return null;
    return QuranReadingPosition(
      surahId: rows.first['surah_id']! as int,
      ayahNumber: rows.first['ayah_number']! as int,
    );
  }

  Future<void> setLastRead(int surahId, int ayahNumber) async {
    final db = await _dbHelper.database;
    final values = {
      'id': 1,
      'surah_id': surahId,
      'ayah_number': ayahNumber,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final existing = await db.query('quran_last_read', where: 'id = 1');
    if (existing.isEmpty) {
      await db.insert('quran_last_read', values);
    } else {
      await db.update('quran_last_read', values, where: 'id = 1');
    }
  }
}
