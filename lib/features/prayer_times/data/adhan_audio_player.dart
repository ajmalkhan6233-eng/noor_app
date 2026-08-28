// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Local-asset-only Adhan playback. Never streams, never fetches
// remote audio — see assets/audio/adhan/README.md for the bundled
// recordings' provenance and licence (Public Domain Mark 1.0).

import 'package:audioplayers/audioplayers.dart';

import 'adhan_reciter.dart';

/// Maps a prayer name to its bundled Adhan asset for the default
/// (`doha`) reciter. `null` for names with no recording (e.g.
/// "Sunrise", which has no Adhan). Kept for callers that don't yet
/// pass a reciter; prefer `adhanAssetFor` from adhan_reciter.dart.
String? adhanAssetForPrayer(String prayerName) =>
    adhanAssetFor(AdhanReciter.doha, prayerName);

/// Thin wrapper so callers (a Cubit, never a widget directly) don't
/// depend on the `audioplayers` package type.
class AdhanAudioPlayer {
  AdhanAudioPlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  /// Fires when the currently-playing clip finishes on its own (as
  /// opposed to being stopped early) — lets callers reset a "playing"
  /// UI state without polling.
  Stream<void> get onComplete => _player.onPlayerComplete;

  /// Plays [reciter]'s Adhan for [prayerName], or does nothing if
  /// there's no recording for it. Stops any currently-playing clip
  /// first, so tapping a different prayer's preview never overlaps
  /// audio.
  Future<void> play(String prayerName, {AdhanReciter reciter = AdhanReciter.doha}) async {
    final asset = adhanAssetFor(reciter, prayerName);
    if (asset == null) return;
    await _player.stop();
    await _player.play(AssetSource(asset));
  }

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
