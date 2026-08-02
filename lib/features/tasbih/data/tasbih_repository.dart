// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file may touch SQL for the tasbih feature. `logic/` never
// sees raw DB rows — only the plain `TasbihSession` model below.

import '../../../core/database/database_helper.dart';

/// Plain persistence model — deliberately separate from `TasbihState`
/// so the DB schema can evolve without reshaping cubit state.
class TasbihSession {
  const TasbihSession({
    required this.dhikrLabel,
    required this.count,
    this.target,
  });

  final String dhikrLabel;
  final int count;
  final int? target;
}

/// Persists and restores tasbih counts from the encrypted local DB.
class TasbihRepository {
  TasbihRepository({DatabaseHelper? databaseHelper})
      : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  /// Saves (or updates) the count for the given dhikr label. All values
  /// are passed as parameterized arguments — never string-interpolated.
  Future<void> saveSession(TasbihSession session) async {
    final db = await _dbHelper.database;
    final existing = await db.query(
      'tasbih_sessions',
      where: 'dhikr_label = ?',
      whereArgs: [session.dhikrLabel],
      limit: 1,
    );

    final values = {
      'dhikr_label': session.dhikrLabel,
      'count': session.count,
      'target': session.target,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (existing.isEmpty) {
      await db.insert('tasbih_sessions', values);
    } else {
      await db.update(
        'tasbih_sessions',
        values,
        where: 'dhikr_label = ?',
        whereArgs: [session.dhikrLabel],
      );
    }
  }

  /// Loads the most recent session for [dhikrLabel], if any.
  Future<TasbihSession?> loadSession(String dhikrLabel) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'tasbih_sessions',
      where: 'dhikr_label = ?',
      whereArgs: [dhikrLabel],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    final row = rows.first;
    return TasbihSession(
      dhikrLabel: row['dhikr_label']! as String,
      count: row['count']! as int,
      target: row['target'] as int?,
    );
  }
}
