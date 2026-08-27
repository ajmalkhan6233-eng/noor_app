// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/backup/backup_crypto.dart';

void main() {
  test('encrypts and decrypts back to the exact original bytes', () async {
    final plaintext = utf8.encode('{"hello":"noor"}');
    final encrypted = await encryptBackup(passphrase: 'correct horse', plaintext: plaintext);

    final decrypted = await decryptBackup(passphrase: 'correct horse', fileBytes: encrypted);

    expect(decrypted, plaintext);
  });

  test('a wrong passphrase fails to decrypt rather than returning garbage', () async {
    final plaintext = utf8.encode('{"hello":"noor"}');
    final encrypted = await encryptBackup(passphrase: 'correct horse', plaintext: plaintext);

    expect(
      () => decryptBackup(passphrase: 'wrong passphrase', fileBytes: encrypted),
      throwsA(isA<BackupDecryptException>()),
    );
  });

  test('a foreign/non-backup file is rejected outright', () async {
    final randomBytes = utf8.encode('just some random text, not a backup');

    expect(
      () => decryptBackup(passphrase: 'anything', fileBytes: randomBytes),
      throwsA(isA<BackupDecryptException>()),
    );
  });

  test('a tampered ciphertext byte fails authentication', () async {
    final plaintext = utf8.encode('{"hello":"noor"}');
    final encrypted = await encryptBackup(passphrase: 'correct horse', plaintext: plaintext);
    final tampered = Uint8List.fromList(encrypted);
    tampered[tampered.length - 1] ^= 0xFF; // flip a bit in the MAC

    expect(
      () => decryptBackup(passphrase: 'correct horse', fileBytes: tampered),
      throwsA(isA<BackupDecryptException>()),
    );
  });
}
