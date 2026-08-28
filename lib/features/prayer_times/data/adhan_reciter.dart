// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Selectable Adhan sound, per direct request (2026-08-28) — reverses
// the earlier 2026-08-23 "ship with the one default reciter only,
// per-reciter selection deferred" call recorded in CLAUDE.md. `doha`
// (the original Public Domain set, one recording per prayer) stays
// the default; the four new options are each a single field recording
// used for every prayer, since none of them are split by prayer name.
// See assets/audio/adhan/README.md for full provenance/licence notes
// on every option, including the one flagged concern (Hamtramck: a
// real muezzin recorded without direct consent — licence is clean,
// content-appropriateness was a real question raised in a prior
// session and is included again here only because it was explicitly
// re-requested).
enum AdhanReciter { doha, indonesia, marrakech, aroumd, hamtramck }

extension AdhanReciterLabel on AdhanReciter {
  String get label => switch (this) {
    AdhanReciter.doha => 'Default (Doha, Qatar)',
    AdhanReciter.indonesia => 'Indonesia',
    AdhanReciter.marrakech => 'Marrakech, Morocco',
    AdhanReciter.aroumd => 'Aroumd, Morocco',
    AdhanReciter.hamtramck => 'Hamtramck, Michigan',
  };

  /// Short attribution line — the actual licence condition for the
  /// four CC-licensed options (`doha` is Public Domain, needs none).
  String? get attribution => switch (this) {
    AdhanReciter.doha => null,
    AdhanReciter.indonesia => '"Adhan-Call to Prayer Selection, Indonesia" '
        'by RTB45 (Freesound.org), CC BY 4.0',
    AdhanReciter.marrakech => '"Call Of Prayer - ADHAN - Marrakech" by '
        'Redalemage (Freesound.org), CC0',
    AdhanReciter.aroumd => '"Adhan (call to prayer), Aroumd, Morocco" by '
        'iainmccurdy (Freesound.org), CC BY 4.0',
    AdhanReciter.hamtramck =>
      '"Islamic Call to Prayer (Dhuhr Adhan), Hamtramck, MI" by '
          'RJStefanski (Freesound.org), CC BY 3.0',
  };
}

/// `doha` (default) has one recording per prayer, matching the
/// original five-file set; every other reciter has one generic
/// recording played regardless of which prayer it's for.
String? adhanAssetFor(AdhanReciter reciter, String prayerName) {
  if (reciter == AdhanReciter.doha) {
    return switch (prayerName) {
      'Fajr' => 'audio/adhan/fajr.mp3',
      'Dhuhr' => 'audio/adhan/dhuhr.mp3',
      'Asr' => 'audio/adhan/asr.mp3',
      'Maghrib' => 'audio/adhan/maghrib.mp3',
      'Isha' => 'audio/adhan/isha.mp3',
      _ => null,
    };
  }
  if (prayerName == 'Sunrise') return null;
  return switch (reciter) {
    AdhanReciter.indonesia => 'audio/adhan/indonesia.mp3',
    AdhanReciter.marrakech => 'audio/adhan/marrakech.mp3',
    AdhanReciter.aroumd => 'audio/adhan/aroumd.mp3',
    AdhanReciter.hamtramck => 'audio/adhan/hamtramck.mp3',
    AdhanReciter.doha => null, // unreachable, handled above
  };
}
