// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sole owner of the app's encrypted SQLite connection. Nothing outside
// `data/` repositories should import `sqflite_sqlcipher` directly —
// route all persistence through repositories that use this helper.

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../security/secure_passphrase_service.dart';
import 'schema/azkar_schema.dart';
import 'schema/quran_schema.dart';
import 'schema/settings_schema.dart';
import 'schema/tasbih_schema.dart';
import 'schema/widget_position_schema.dart';

/// Singleton factory for the app's encrypted local database.
///
/// Fully offline: the database file lives in the app's private storage
/// directory and is never synced or transmitted anywhere. Encrypted
/// with a random passphrase generated on first launch and kept only
/// in the OS Keystore/Keychain — see [SecurePassphraseService].
class DatabaseHelper {
  DatabaseHelper._internal({SecurePassphraseService? passphraseService})
    : _passphraseService = passphraseService ?? const SecurePassphraseService();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  final SecurePassphraseService _passphraseService;

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
    final passphrase = await _passphraseService.getOrCreatePassphrase();

    return openDatabase(
      path,
      version: _dbVersion,
      password: passphrase,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final statement in [
      ...tasbihCreateStatements,
      ...settingsCreateStatements,
      ...azkarCreateStatements,
      ...quranCreateStatements,
      ...widgetPositionCreateStatements,
    ]) {
      await db.execute(statement);
    }
    for (final statement in azkarSeedStatements) {
      await db.execute(statement);
    }
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
