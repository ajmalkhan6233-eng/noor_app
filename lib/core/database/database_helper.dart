// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sole owner of the app's encrypted SQLite connection. Nothing outside
// `data/` repositories should import `sqflite_sqlcipher` directly —
// route all persistence through repositories that use this helper.

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../security/secure_passphrase_service.dart';
import 'database_migrations.dart';

/// Singleton factory for the app's encrypted local database.
///
/// Fully offline: the database file lives in the app's private storage
/// directory and is never synced or transmitted anywhere. Encrypted
/// with a random passphrase generated on first launch and kept only
/// in the OS Keystore/Keychain — see [SecurePassphraseService].
class DatabaseHelper {
  DatabaseHelper._internal({SecurePassphraseService? passphraseService})
    : _passphraseService = passphraseService ?? const SecurePassphraseService();

  /// Test-only seam: wraps an already-open [Database] (e.g. an
  /// in-memory `sqflite_common_ffi` database in a unit test) so
  /// repositories can be exercised without the real encrypted-DB
  /// bootstrap (secure passphrase storage, platform channels).
  DatabaseHelper.forTesting(Database db)
    : _passphraseService = const SecurePassphraseService(),
      _database = db;

  static final DatabaseHelper instance = DatabaseHelper._internal();

  final SecurePassphraseService _passphraseService;

  static const String _dbName = 'noor.db';
  static const int _dbVersion = latestSchemaVersion;

  Database? _database;

  /// Returns the open database, initializing it on first access.
  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;
    final opened = await _open();
    _database = opened;
    return opened;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = join(dir, _dbName);
    final passphrase = await _passphraseService.getOrCreatePassphrase();

    return openDatabase(
      path,
      version: _dbVersion,
      password: passphrase,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Actual schema logic lives in database_migrations.dart, as plain
  // top-level functions — that's what lets migration_test.dart
  // exercise the real create/upgrade path without needing this
  // class's real encrypted-DB bootstrap (secure passphrase, platform
  // channels), which isn't available under `flutter test`.
  Future<void> _onCreate(Database db, int version) => createNoorSchema(db, version);

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) =>
      upgradeNoorSchema(db, oldVersion, newVersion);

  /// Closes the database (mainly useful for tests).
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }

  /// Test-only hook: point the helper at an in-memory DB path.
  static bool get isMobile =>
      Platform.isAndroid || Platform.isIOS; // used by callers to gate APIs
}
