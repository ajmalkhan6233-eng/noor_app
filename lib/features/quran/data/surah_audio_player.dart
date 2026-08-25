// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Local-asset-only Quran recitation playback, bundled for Juz Amma
// only (surahs 78-114) — see assets/quran/audio/README.md for why:
// full-Quran audio at even the lowest available bitrate is ~294MB,
// more than 3x the whole app at the time this was added, and this
// app's zero-INTERNET-permission rule rules out streaming the rest.
// Same "never streams, never fetches remote audio" rule as the Adhan
// recordings.

import 'package:audioplayers/audioplayers.dart';

/// `true` for surahs 78-114 (Juz Amma) — the only ones with a bundled
/// recording. Callers use this to decide whether to show a play
/// control at all, rather than showing one that always fails.
bool hasSurahAudio(int surahId) => surahId >= 78 && surahId <= 114;

String? surahAudioAsset(int surahId) {
  if (!hasSurahAudio(surahId)) return null;
  final padded = surahId.toString().padLeft(3, '0');
  return 'quran/audio/juz_amma/$padded.m4a';
}

/// Thin wrapper so callers (a screen, not a widget tree directly)
/// don't depend on the `audioplayers` package type.
class SurahAudioPlayer {
  SurahAudioPlayer({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  Stream<void> get onComplete => _player.onPlayerComplete;

  /// Plays the recitation for [surahId], or does nothing if it isn't
  /// bundled. Stops any currently-playing clip first.
  Future<void> play(int surahId) async {
    final asset = surahAudioAsset(surahId);
    if (asset == null) return;
    await _player.stop();
    await _player.play(AssetSource(asset));
  }

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
