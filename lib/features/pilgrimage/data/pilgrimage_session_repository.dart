// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Owns all SQL for `pilgrimage_session`. Completing a session also
// bumps the owning profile's lifetime counter, via
// `PilgrimProfileRepository` — never by reaching into its table
// directly.

import '../../../core/database/database_helper.dart';
import 'pilgrim_profile_repository.dart';
import 'pilgrimage_session.dart';

/// Persists and restores pilgrimage sessions from the encrypted DB.
class PilgrimageSessionRepository {
  PilgrimageSessionRepository({
    DatabaseHelper? databaseHelper,
    PilgrimProfileRepository? profileRepository,
  }) : _dbHelper = databaseHelper ?? DatabaseHelper.instance,
       _profiles = profileRepository ?? PilgrimProfileRepository();

  final DatabaseHelper _dbHelper;
  final PilgrimProfileRepository _profiles;

  /// The most recent unfinished session for [pilgrimId], if any — used
  /// to resume automatically after the app is closed mid-ritual.
  Future<PilgrimageSession?> incompleteSessionFor(int pilgrimId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'pilgrimage_session',
      where: 'pilgrim_id = ? AND is_completed = 0',
      whereArgs: [pilgrimId],
      orderBy: 'session_id DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  /// Starts a brand-new session for [pilgrimId].
  Future<PilgrimageSession> createSession({
    required int pilgrimId,
    required PilgrimageType type,
  }) async {
    final db = await _dbHelper.database;
    final startTime = DateTime.now();
    final sessionId = await db.insert('pilgrimage_session', {
      'pilgrim_id': pilgrimId,
      'type': type.value,
      'current_step': PilgrimageStep.tawaf,
      'tawaf_circuit_count': 0,
      'sai_round_count': 0,
      'is_completed': 0,
      'start_time': startTime.toIso8601String(),
    });
    return PilgrimageSession(
      sessionId: sessionId,
      pilgrimId: pilgrimId,
      type: type,
      currentStep: PilgrimageStep.tawaf,
      startTime: startTime,
    );
  }

  /// Updates the Tawaf circuit count (0-7) for [sessionId].
  Future<void> updateTawafCount(int sessionId, int count) async {
    await _updateColumn(sessionId, 'tawaf_circuit_count', count);
  }

  /// Updates the Sa'i round count (0-7) for [sessionId].
  Future<void> updateSaiCount(int sessionId, int count) async {
    await _updateColumn(sessionId, 'sai_round_count', count);
  }

  /// Moves [sessionId] to the given [step] (see [PilgrimageStep]).
  Future<void> updateCurrentStep(int sessionId, int step) async {
    await _updateColumn(sessionId, 'current_step', step);
  }

  /// Marks [session] complete, stamps `end_time`, and increments the
  /// owning profile's lifetime Umrah/Hajj counter.
  Future<void> completeSession(PilgrimageSession session) async {
    final db = await _dbHelper.database;
    final endTime = DateTime.now();
    await db.update(
      'pilgrimage_session',
      {
        'is_completed': 1,
        'current_step': PilgrimageStep.done,
        'end_time': endTime.toIso8601String(),
      },
      where: 'session_id = ?',
      whereArgs: [session.sessionId],
    );

    if (session.type == PilgrimageType.umrah) {
      await _profiles.incrementUmrahCompleted(session.pilgrimId);
    } else {
      await _profiles.incrementHajjCompleted(session.pilgrimId);
    }
  }

  Future<void> _updateColumn(int sessionId, String column, int value) async {
    final db = await _dbHelper.database;
    // `column` is always one of the two fixed literals passed by the
    // methods above — never externally supplied — so this stays safe
    // despite SQL placeholders being unable to parameterize identifiers.
    await db.update(
      'pilgrimage_session',
      {column: value},
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }

  PilgrimageSession _fromRow(Map<String, Object?> row) {
    return PilgrimageSession(
      sessionId: row['session_id']! as int,
      pilgrimId: row['pilgrim_id']! as int,
      type: pilgrimageTypeFromValue(row['type']! as String),
      currentStep: row['current_step']! as int,
      tawafCircuitCount: row['tawaf_circuit_count']! as int,
      saiRoundCount: row['sai_round_count']! as int,
      isCompleted: (row['is_completed']! as int) == 1,
      startTime: DateTime.parse(row['start_time']! as String),
      endTime: row['end_time'] == null
          ? null
          : DateTime.parse(row['end_time']! as String),
    );
  }
}
