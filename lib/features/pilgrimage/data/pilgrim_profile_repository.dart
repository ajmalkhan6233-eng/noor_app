// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Only this file (and `pilgrimage_session_repository.dart`) may touch
// SQL for the pilgrimage feature. `logic/` never sees raw DB rows —
// only the plain `PilgrimProfile` model.

import '../../../core/database/database_helper.dart';
import 'pilgrim_profile.dart';

/// Persists and restores pilgrim profiles from the encrypted local DB.
class PilgrimProfileRepository {
  PilgrimProfileRepository({DatabaseHelper? databaseHelper})
    : _dbHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  /// All known profiles, most recently created first.
  Future<List<PilgrimProfile>> listProfiles() async {
    final db = await _dbHelper.database;
    final rows = await db.query('pilgrim_profile', orderBy: 'id DESC');
    return rows.map(_fromRow).toList();
  }

  /// Finds a profile by its exact [displayName], if one exists.
  Future<PilgrimProfile?> findByName(String displayName) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'pilgrim_profile',
      where: 'display_name = ?',
      whereArgs: [displayName],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  /// Creates a new profile and returns it with its assigned [id].
  Future<PilgrimProfile> createProfile({
    required String displayName,
    required PilgrimExperienceLevel experienceLevel,
    String? preferredLanguage,
  }) async {
    final db = await _dbHelper.database;
    final createdAt = DateTime.now();
    final id = await db.insert('pilgrim_profile', {
      'display_name': displayName,
      'total_umrah_completed': 0,
      'total_hajj_completed': 0,
      'experience_level': experienceLevel.value,
      'preferred_language': preferredLanguage,
      'created_at': createdAt.toIso8601String(),
    });
    return PilgrimProfile(
      id: id,
      displayName: displayName,
      experienceLevel: experienceLevel,
      preferredLanguage: preferredLanguage,
      createdAt: createdAt,
    );
  }

  /// Increments the lifetime completed-Umrah counter for [pilgrimId].
  Future<void> incrementUmrahCompleted(int pilgrimId) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      'UPDATE pilgrim_profile '
      'SET total_umrah_completed = total_umrah_completed + 1 '
      'WHERE id = ?',
      [pilgrimId],
    );
  }

  /// Increments the lifetime completed-Hajj counter for [pilgrimId].
  Future<void> incrementHajjCompleted(int pilgrimId) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      'UPDATE pilgrim_profile '
      'SET total_hajj_completed = total_hajj_completed + 1 '
      'WHERE id = ?',
      [pilgrimId],
    );
  }

  PilgrimProfile _fromRow(Map<String, Object?> row) {
    return PilgrimProfile(
      id: row['id']! as int,
      displayName: row['display_name']! as String,
      totalUmrahCompleted: row['total_umrah_completed']! as int,
      totalHajjCompleted: row['total_hajj_completed']! as int,
      experienceLevel: pilgrimExperienceLevelFromValue(
        row['experience_level']! as String,
      ),
      preferredLanguage: row['preferred_language'] as String?,
      createdAt: DateTime.parse(row['created_at']! as String),
    );
  }
}
