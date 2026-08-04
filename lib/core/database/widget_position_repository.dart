// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file touches the `widget_positions` table.

import 'package:flutter/material.dart';

import 'database_helper.dart';

class WidgetPositionRepository {
  WidgetPositionRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<Offset?> load(String widgetKey) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'widget_positions',
      where: 'widget_key = ?',
      whereArgs: [widgetKey],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Offset(rows.first['dx']! as double, rows.first['dy']! as double);
  }

  Future<void> save(String widgetKey, Offset position) async {
    final db = await _dbHelper.database;
    final values = {
      'widget_key': widgetKey,
      'dx': position.dx,
      'dy': position.dy,
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

  Future<void> clear(String widgetKey) async {
    final db = await _dbHelper.database;
    await db.delete(
      'widget_positions',
      where: 'widget_key = ?',
      whereArgs: [widgetKey],
    );
  }
}
