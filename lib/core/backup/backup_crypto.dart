// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// AES-256-GCM with a PBKDF2-derived key — a user-chosen passphrase,
// never the app's own DB passphrase (that one's Keystore-bound and
// meaningless off this specific device; a backup has to open on any
// device). GCM is authenticated: a wrong passphrase or a corrupted/
// tampered file fails decryption outright rather than silently
// producing garbage data that could get written into the live DB.

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// First 4 bytes of every backup file — lets a bad/foreign file be
/// rejected immediately with a clear message instead of a confusing
/// decrypt failure several steps later.
final Uint8List backupFileMagic = Uint8List.fromList(utf8.encode('NRBK'));
const int backupFormatVersion = 1;
const int _saltLength = 16;
const int _pbkdf2Iterations = 200000;

class BackupDecryptException implements Exception {
  const BackupDecryptException(this.message);
  final String message;
  @override
  String toString() => message;
}

Future<Uint8List> encryptBackup({
  required String passphrase,
  required Uint8List plaintext,
}) async {
  final salt = _randomBytes(_saltLength);
  final algorithm = AesGcm.with256bits();
  final secretKey = await _deriveKey(passphrase, salt);
  final nonce = algorithm.newNonce();

  final secretBox = await algorithm.encrypt(plaintext, secretKey: secretKey, nonce: nonce);

  final builder = BytesBuilder();
  builder.add(backupFileMagic);
  builder.addByte(backupFormatVersion);
  builder.add(salt);
  builder.add(nonce);
  builder.add(secretBox.cipherText);
  builder.add(secretBox.mac.bytes);
  return builder.toBytes();
}

/// Throws [BackupDecryptException] for anything that isn't a genuine,
/// correctly-decrypted noor backup — a wrong passphrase, a foreign
/// file, or a corrupted one. Never returns partial or best-guess data.
Future<Uint8List> decryptBackup({
  required String passphrase,
  required Uint8List fileBytes,
}) async {
  const macLength = 16; // AES-GCM tag length in bytes.
  const nonceLength = 12; // AesGcm.with256bits()'s nonce length.
  final headerLength = backupFileMagic.length + 1 + _saltLength + nonceLength;
  if (fileBytes.length < headerLength + macLength) {
    throw const BackupDecryptException('Not a valid noor backup file.');
  }
  var offset = 0;
  final magic = fileBytes.sublist(offset, offset += backupFileMagic.length);
  if (!_bytesEqual(magic, backupFileMagic)) {
    throw const BackupDecryptException('Not a valid noor backup file.');
  }
  final version = fileBytes[offset++];
  if (version != backupFormatVersion) {
    throw BackupDecryptException('Unsupported backup file version: $version.');
  }
  final salt = fileBytes.sublist(offset, offset += _saltLength);
  final nonce = fileBytes.sublist(offset, offset += nonceLength);
  final cipherText = fileBytes.sublist(offset, fileBytes.length - macLength);
  final mac = fileBytes.sublist(fileBytes.length - macLength);

  final algorithm = AesGcm.with256bits();
  final secretKey = await _deriveKey(passphrase, salt);
  try {
    final plaintext = await algorithm.decrypt(
      SecretBox(cipherText, nonce: nonce, mac: Mac(mac)),
      secretKey: secretKey,
    );
    return Uint8List.fromList(plaintext);
  } on SecretBoxAuthenticationError {
    throw const BackupDecryptException('Wrong passphrase, or the file is corrupted.');
  }
}

Future<SecretKey> _deriveKey(String passphrase, List<int> salt) {
  final pbkdf2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: _pbkdf2Iterations, bits: 256);
  return pbkdf2.deriveKeyFromPassword(password: passphrase, nonce: salt);
}

Uint8List _randomBytes(int length) {
  final random = Random.secure();
  return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
}

bool _bytesEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
