// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Where each ayah starts inside a bundled surah recitation, so tapping
// an ayah plays from that ayah (2026-11-19). The numbers come from a
// one-time forced alignment of the CC BY recordings against the
// verified Tanzil text (tools/ayah_align/align.py) and are only listed
// here for surahs that passed review; any surah missing here simply
// keeps whole-surah playback.

import 'dart:convert';

import 'package:flutter/services.dart';

const String ayahTimingsAsset = 'assets/quran/ayah_timings.json';

/// surah number -> start of each ayah in milliseconds (index 0 = ayah 1).
typedef AyahTimingTable = Map<int, List<int>>;

/// Parses the asset. Rejects (drops) any surah whose list is not
/// strictly increasing, so a bad entry can never seek backwards.
AyahTimingTable parseAyahTimings(String json) {
  final root = jsonDecode(json) as Map<String, dynamic>;
  final surahs = (root['surahs'] as Map<String, dynamic>?) ?? const {};
  final table = <int, List<int>>{};
  surahs.forEach((key, value) {
    final starts = (value as List).map((e) => (e as num).toInt()).toList();
    for (var i = 1; i < starts.length; i++) {
      if (starts[i] <= starts[i - 1]) return;
    }
    if (starts.isNotEmpty && starts.first >= 0) table[int.parse(key)] = starts;
  });
  return table;
}

/// Start of [ayah] in [surah], or null when this surah has no timings.
Duration? ayahStart(AyahTimingTable table, int surah, int ayah) {
  final starts = table[surah];
  if (starts == null || ayah < 1 || ayah > starts.length) return null;
  return Duration(milliseconds: starts[ayah - 1]);
}

AyahTimingTable? _cache;

Future<AyahTimingTable> loadAyahTimings({AssetBundle? bundle}) async {
  if (_cache != null) return _cache!;
  try {
    _cache = parseAyahTimings(await (bundle ?? rootBundle).loadString(ayahTimingsAsset));
  } catch (_) {
    _cache = {};
  }
  return _cache!;
}
