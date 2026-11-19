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

/// The res/raw sound used for [prayerName] with [reciter] — the same
/// file the adhan notification plays (see notification_details.dart),
/// and what the preview plays (AdhanPreviewChannel.kt). `doha` has one
/// recording per prayer; every other reciter has one generic recording.
/// Null for Sunrise and unknown names (no adhan).
String? adhanRawResourceFor(AdhanReciter reciter, String prayerName) {
  const prayers = {'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'};
  if (!prayers.contains(prayerName)) return null;
  return reciter == AdhanReciter.doha
      ? 'adhan_${prayerName.toLowerCase()}'
      : 'adhan_${reciter.name}';
}
