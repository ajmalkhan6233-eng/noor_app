// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reads/writes only the `motion_mode` column of the single-row
// `app_settings` table. Kept out of settings_repository.dart, which is
// already at the 150-line limit.

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../core/database/database_helper.dart';

class SettingsMotionPersistence {
  static const String defaultMode = 'Full';

  static Future<String> load({DatabaseHelper? databaseHelper}) async {
    if (kIsWeb) return defaultMode;
    final db = await (databaseHelper ?? DatabaseHelper.instance).database;
    final rows = await db.query(
      'app_settings',
      columns: ['motion_mode'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return defaultMode;
    return (rows.first['motion_mode'] as String?) ?? defaultMode;
  }

  static Future<void> save(String mode, {DatabaseHelper? databaseHelper}) async {
    if (kIsWeb) return;
    final db = await (databaseHelper ?? DatabaseHelper.instance).database;
    // The row always exists by now: the cubit saves the full settings
    // first (see SettingsCubit.setMotionMode).
    await db.update(
      'app_settings',
      {'motion_mode': mode},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
