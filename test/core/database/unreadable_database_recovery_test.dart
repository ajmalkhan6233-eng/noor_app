// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/unreadable_database_recovery.dart';

void main() {
  test('only the wrong-key / not-a-database error counts', () {
    expect(isUnreadableDatabaseError(Exception('file is not a database (code 26)')), isTrue);
    expect(isUnreadableDatabaseError('DatabaseException(SQLITE_NOTADB)'), isTrue);
    expect(isUnreadableDatabaseError(Exception('database is locked (code 5)')), isFalse);
    expect(isUnreadableDatabaseError(Exception('disk I/O error')), isFalse);
  });

  test('quarantine renames the file and companions, deletes nothing', () async {
    final dir = await Directory.systemTemp.createTemp('noor_db_test');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/noor.db';
    await File(path).writeAsString('old');
    await File('$path-wal').writeAsString('wal');
    final when = DateTime.fromMillisecondsSinceEpoch(1700000000000);

    final moved = await quarantineDatabaseFile(path, now: when);

    expect(moved, isTrue);
    expect(File(path).existsSync(), isFalse);
    expect(File('$path.unreadable-1700000000000').readAsStringSync(), 'old');
    expect(File('$path-wal.unreadable-1700000000000').existsSync(), isTrue);
  });

  test('quarantine with no file is a no-op', () async {
    final dir = await Directory.systemTemp.createTemp('noor_db_test');
    addTearDown(() => dir.delete(recursive: true));
    expect(await quarantineDatabaseFile('${dir.path}/missing.db'), isFalse);
  });
}
