// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sole owner of the app's encrypted SQLite connection. Nothing outside
// `data/` repositories should import `sqflite_sqlcipher` directly —
// route all persistence through repositories that use this helper.

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Singleton factory for the app's encrypted local database.
///
/// Fully offline: the database file lives in the app's private storage
/// directory and is never synced or transmitted anywhere.
class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'noor.db';
  static const int _dbVersion = 1;

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

    // NOTE: replace `_passphrase` with a passphrase pulled from secure
    // platform storage (e.g. flutter_secure_storage) before shipping —
    // never hardcode the real passphrase in source.
    const passphrase = String.fromEnvironment(
      'NOOR_DB_PASSPHRASE',
      defaultValue: 'change-me-before-release',
    );

    return openDatabase(
      path,
      version: _dbVersion,
      password: passphrase,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasbih_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dhikr_label TEXT NOT NULL,
        count INTEGER NOT NULL DEFAULT 0,
        target INTEGER,
        updated_at TEXT NOT NULL
      )
    ''');
  }

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
