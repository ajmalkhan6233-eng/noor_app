// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reads the bundled, SHA-256-verified Tawaf/Sa'i dua asset. No dua
// text is ever generated here — this only ever moves bytes shipped in
// `assets/pilgrimage/` (see the README there for provenance) into a
// plain Dart model, after verification. Returns null on any mismatch
// or missing asset so the caller falls back to the "not yet loaded"
// message rather than showing anything unverified.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

import 'pilgrimage_dua.dart';

class PilgrimageDuaRepository {
  const PilgrimageDuaRepository();

  static const assetPath = 'assets/pilgrimage/hisn-tawaf-sai.json';

  /// SHA-256 of the exact bytes in [assetPath] — see
  /// `assets/pilgrimage/README.md` for source and licence.
  static const expectedSha256 =
      '809d86bafe27c90cab58911609d91751d6391fe6fe61f63b66259e8668465e04';

  Future<PilgrimageDua?> forKey(String key) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      if (sha256.convert(bytes).toString() != expectedSha256) return null;

      final entries = jsonDecode(utf8.decode(bytes)) as List<dynamic>;
      final match = entries.cast<Map<String, dynamic>>().firstWhere(
        (entry) => entry['key'] == key,
        orElse: () => const {},
      );
      final text = match['content'] as String?;
      if (text == null || text.isEmpty) return null;
      return PilgrimageDua(
        arabicText: text,
        repeatCount: (match['count'] as int?) ?? 1,
        source: (match['source'] as String?) ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
