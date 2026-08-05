// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches the `widget_positions` table.

import 'package:flutter/material.dart';

import 'database_helper.dart';

/// Position plus size for a widget that supports pinch-to-resize (the
/// Qibla compass); plain drag-only widgets (Tasbih, Settings gear)
/// keep using [WidgetPositionRepository.load]/[save], which never
/// touch the `scale` column.
class WidgetPositionRecord {
  const WidgetPositionRecord({required this.offset, required this.scale});
  final Offset offset;
  final double scale;
}

class WidgetPositionRepository {
  WidgetPositionRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<Offset?> load(String widgetKey) async {
    final row = await _row(widgetKey);
    if (row == null) return null;
    return Offset(row['dx']! as double, row['dy']! as double);
  }

  Future<void> save(String widgetKey, Offset position) async {
    await _upsert(widgetKey, position, scale: null);
  }

  Future<WidgetPositionRecord?> loadWithScale(String widgetKey) async {
    final row = await _row(widgetKey);
    if (row == null) return null;
    return WidgetPositionRecord(
      offset: Offset(row['dx']! as double, row['dy']! as double),
      scale: (row['scale'] as double?) ?? 1.0,
    );
  }

  Future<void> saveWithScale(
    String widgetKey,
    Offset position,
    double scale,
  ) async {
    await _upsert(widgetKey, position, scale: scale);
  }

  Future<void> clear(String widgetKey) async {
    final db = await _dbHelper.database;
    await db.delete(
      'widget_positions',
      where: 'widget_key = ?',
      whereArgs: [widgetKey],
    );
  }

  Future<Map<String, Object?>?> _row(String widgetKey) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'widget_positions',
      where: 'widget_key = ?',
      whereArgs: [widgetKey],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> _upsert(
    String widgetKey,
    Offset position, {
    required double? scale,
  }) async {
    final db = await _dbHelper.database;
    final values = {
      'widget_key': widgetKey,
      'dx': position.dx,
      'dy': position.dy,
      if (scale != null) 'scale': scale,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final existing = await db.query(
      'widget_positions',
      where: 'widget_key = ?',
      whereArgs: [widgetKey],
    );
    if (existing.isEmpty) {
      await db.insert('widget_positions', values);
    } else {
      await db.update(
        'widget_positions',
        values,
        where: 'widget_key = ?',
        whereArgs: [widgetKey],
      );
    }
  }
}
