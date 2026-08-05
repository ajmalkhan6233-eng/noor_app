import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Single source of truth for the encrypted local database connection.
/// No feature repository should open its own database handle — all
/// access goes through `DatabaseHelper.instance.database`.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _dbName = 'noor.db';
  static const int _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    final passphrase = await _resolvePassphrase();

    return openDatabase(
      path,
      password: passphrase,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  /// Release blocker (tracked, not solved here): this must read from
  /// Android Keystore-backed secure storage before Play Store submission.
  /// Left as an explicit placeholder rather than a silent hardcoded
  /// secret so it can't ship unnoticed.
  Future<String> _resolvePassphrase() async {
    return 'noor_dev_passphrase_change_me';
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasbih_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dhikr_label TEXT NOT NULL,
        count INTEGER NOT NULL DEFAULT 0,
        target INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
