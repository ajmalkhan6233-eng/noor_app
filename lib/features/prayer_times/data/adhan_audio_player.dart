// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Local-asset-only Adhan playback. Never streams, never fetches
// remote audio — see assets/audio/adhan/README.md for the bundled
// recordings' provenance and licence (Public Domain Mark 1.0).

import 'package:audioplayers/audioplayers.dart';

/// Maps a prayer name to its bundled Adhan asset. `null` for names
/// with no recording (e.g. "Sunrise", which has no Adhan).
String? adhanAssetForPrayer(String prayerName) => switch (prayerName) {
  'Fajr' => 'audio/adhan/fajr.mp3',
  'Dhuhr' => 'audio/adhan/dhuhr.mp3',
  'Asr' => 'audio/adhan/asr.mp3',
  'Maghrib' => 'audio/adhan/maghrib.mp3',
  'Isha' => 'audio/adhan/isha.mp3',
  _ => null,
};

/// Thin wrapper so callers (a Cubit, never a widget directly) don't
/// depend on the `audioplayers` package type.
class AdhanAudioPlayer {
  AdhanAudioPlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  /// Fires when the currently-playing clip finishes on its own (as
  /// opposed to being stopped early) — lets callers reset a "playing"
  /// UI state without polling.
  Stream<void> get onComplete => _player.onPlayerComplete;

  /// Plays the Adhan for [prayerName], or does nothing if there's no
  /// recording for it. Stops any currently-playing clip first, so
  /// tapping a different prayer's preview never overlaps audio.
  Future<void> play(String prayerName) async {
    final asset = adhanAssetForPrayer(prayerName);
    if (asset == null) return;
    await _player.stop();
    await _player.play(AssetSource(asset));
  }

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
