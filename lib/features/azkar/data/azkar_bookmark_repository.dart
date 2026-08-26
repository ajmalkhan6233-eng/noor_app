// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of azkar_repository.dart to stay under the 150-line-per-
// file rule. Bookmarks let someone build their own set of duas to
// return to daily — direct request (2026-08-26), mirroring the
// Quran tab's existing bookmark feature.

import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../core/database/database_helper.dart';
import 'azkar_item.dart';

class AzkarBookmarkRepository {
  AzkarBookmarkRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<Set<int>> bookmarkedItemIds() async {
    final db = await _dbHelper.database;
    final rows = await db.query('azkar_bookmarks');
    return {for (final row in rows) row['item_id']! as int};
  }

  Future<void> setBookmarked(int itemId, bool bookmarked) async {
    final db = await _dbHelper.database;
    if (bookmarked) {
      await db.insert(
        'azkar_bookmarks',
        {'item_id': itemId, 'created_at': DateTime.now().toIso8601String()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.delete('azkar_bookmarks', where: 'item_id = ?', whereArgs: [itemId]);
    }
  }

  /// Every bookmarked item, most recently bookmarked first.
  Future<List<AzkarItem>> bookmarkedItems() async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery('''
      SELECT azkar_items.* FROM azkar_items
      JOIN azkar_bookmarks ON azkar_bookmarks.item_id = azkar_items.id
      ORDER BY azkar_bookmarks.created_at DESC
    ''');
    return [
      for (final row in rows)
        AzkarItem(
          id: row['id']! as int,
          arabicText: row['arabic_text']! as String,
          transliteration: row['transliteration'] as String?,
          translation: row['translation'] as String?,
          repeatCount: row['repeat_count']! as int,
          source: row['source']! as String,
        ),
    ];
  }
}
