// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Generates and stores the database passphrase. The passphrase never
// appears in source: a fresh 256-bit value is generated on first
// launch with a CSPRNG and handed to the OS Keystore/Keychain via
// flutter_secure_storage — nothing about it is ever written to a
// plain file or transmitted anywhere.

import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Owns the database passphrase's lifecycle: generate once, reuse
/// forever after.
class SecurePassphraseService {
  const SecurePassphraseService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _storageKey = 'noor_db_passphrase_v1';

  /// Returns the existing passphrase, or generates, persists, and
  /// returns a new random one on first call.
  Future<String> getOrCreatePassphrase() async {
    final existing = await _storage.read(key: _storageKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final generated = _generatePassphrase();
    await _storage.write(key: _storageKey, value: generated);
    return generated;
  }

  /// 256 bits from a cryptographically secure RNG, hex-encoded.
  String _generatePassphrase() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
