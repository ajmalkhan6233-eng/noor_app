// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches the `azkar_*` tables. `azkar_items` is
// populated by AzkarImportService from checksum-verified, attributed
// datasets (see `assets/azkar/README.md`); every row carries a
// mandatory `source`.

import '../../../core/database/database_helper.dart';
import 'azkar_category.dart';
import 'azkar_item.dart';

class AzkarRepository {
  AzkarRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  /// Items for [category], in display order. Empty until a
  /// collection is imported.
  Future<List<AzkarItem>> itemsForCategory(AzkarCategory category) async {
    final db = await _dbHelper.database;
    final categoryRows = await db.query(
      'azkar_categories',
      where: 'category_key = ?',
      whereArgs: [category.dbKey],
      limit: 1,
    );
    if (categoryRows.isEmpty) return [];

    final categoryId = categoryRows.first['id']! as int;
    final itemRows = await db.query(
      'azkar_items',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'display_order ASC',
    );

    return [
      for (final row in itemRows)
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

  /// Every item across every category whose transliteration or
  /// translation contains [query] (case-insensitive) — lets someone
  /// type e.g. "sleep" and find the relevant dua without knowing
  /// which category it lives in first.
  Future<List<(AzkarCategory category, AzkarItem item)>> searchItems(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final db = await _dbHelper.database;
    final rows = await db.rawQuery(
      '''
      SELECT azkar_items.*, azkar_categories.category_key AS category_key
      FROM azkar_items
      JOIN azkar_categories ON azkar_categories.id = azkar_items.category_id
      WHERE LOWER(azkar_items.transliteration) LIKE ?
         OR LOWER(azkar_items.translation) LIKE ?
      ORDER BY azkar_categories.id ASC, azkar_items.display_order ASC
      ''',
      ['%${trimmed.toLowerCase()}%', '%${trimmed.toLowerCase()}%'],
    );

    final results = <(AzkarCategory, AzkarItem)>[];
    for (final row in rows) {
      final matches = AzkarCategory.values.where((c) => c.dbKey == row['category_key']);
      if (matches.isEmpty) continue;
      final category = matches.first;
      results.add((
        category,
        AzkarItem(
          id: row['id']! as int,
          arabicText: row['arabic_text']! as String,
          transliteration: row['transliteration'] as String?,
          translation: row['translation'] as String?,
          repeatCount: row['repeat_count']! as int,
          source: row['source']! as String,
        ),
      ));
    }
    return results;
  }

  /// Current repetition count for [itemId] (0 if never started).
  Future<int> progressFor(int itemId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'azkar_progress',
      where: 'item_id = ?',
      whereArgs: [itemId],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return rows.first['count']! as int;
  }

  Future<int> incrementProgress(int itemId) async {
    final current = await progressFor(itemId);
    final next = current + 1;
    await _upsertProgress(itemId, next);
    return next;
  }

  Future<void> resetProgress(int itemId) => _upsertProgress(itemId, 0);

  Future<void> _upsertProgress(int itemId, int count) async {
    final db = await _dbHelper.database;
    final values = {
      'item_id': itemId,
      'count': count,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final existing = await db.query(
      'azkar_progress',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    if (existing.isEmpty) {
      await db.insert('azkar_progress', values);
    } else {
      await db.update(
        'azkar_progress',
        values,
        where: 'item_id = ?',
        whereArgs: [itemId],
      );
    }
  }
}
