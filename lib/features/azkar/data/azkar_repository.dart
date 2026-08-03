// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches the `azkar_*` tables. `azkar_items` starts
// empty (see `azkar_schema.dart`) — TODO: import a properly sourced
// collection; every row that lands there carries a mandatory `source`.

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
