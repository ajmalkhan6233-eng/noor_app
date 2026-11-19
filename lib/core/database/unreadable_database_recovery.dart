// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// When a phone maker's backup restores the encrypted database file but
// not the Android Keystore key that unlocks its passphrase, the old
// file can never be opened again: every screen that needs the database
// would fail forever. This keeps the app usable: the unreadable file is
// renamed (never deleted, so nothing is destroyed) and a fresh database
// is created. It only triggers on SQLCipher's "file is not a database"
// error — any other failure is rethrown untouched, so a healthy
// database is never moved aside.

import 'dart:io';

/// True for the SQLCipher/SQLite error that means "wrong key or not a
/// database" (SQLITE_NOTADB, code 26). Pure, so it is unit-tested.
bool isUnreadableDatabaseError(Object error) {
  final text = error.toString().toLowerCase();
  return text.contains('file is not a database') ||
      text.contains('sqlite_notadb') ||
      text.contains('(code 26)');
}

/// Renames [path] (and its -wal/-shm/-journal companions) to
/// `<path>.unreadable-<millis>`. Returns true when the main file moved.
Future<bool> quarantineDatabaseFile(String path, {DateTime? now}) async {
  final stamp = (now ?? DateTime.now()).millisecondsSinceEpoch;
  var moved = false;
  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final file = File('$path$suffix');
    if (!await file.exists()) continue;
    await file.rename('$path$suffix.unreadable-$stamp');
    if (suffix.isEmpty) moved = true;
  }
  return moved;
}
