// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reads the bundled, SHA-256-verified Talbiyah asset. No Talbiyah text
// is ever generated here — this only ever moves bytes shipped in
// `assets/talbiyah/` (see the README there for provenance) into a
// plain Dart model, after verification. Returns null on any mismatch
// or missing asset so the caller falls back to the "not yet loaded"
// message rather than showing anything unverified.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

import 'talbiyah_entry.dart';

class TalbiyahRepository {
  const TalbiyahRepository();

  static const assetPath = 'assets/talbiyah/talbiyah-ar.json';

  /// SHA-256 of the exact bytes in [assetPath] — see
  /// `assets/talbiyah/README.md` for source and licence.
  static const expectedSha256 =
      '21a4772a5ff8fc5238978239e2f379cf41f298331a83ee46d107b79adfd431e2';

  Future<TalbiyahEntry?> load() async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      if (sha256.convert(bytes).toString() != expectedSha256) return null;

      final map = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final text = map['text'] as String?;
      if (text == null || text.isEmpty) return null;
      return TalbiyahEntry(
        arabicText: text,
        reference: (map['reference'] as String?) ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
