// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Quran recitation playback. Bundled for Juz Amma (surahs 78-114 —
// see assets/quran/audio/juz_amma/README.md for why: full-Quran audio
// at even the lowest available bitrate is ~294MB, more than 3x the
// whole app, too large to bundle for every surah) plus four
// individually curated surahs — Al-Kahf (18), Ya-Sin (36), Ar-Rahman
// (55), Al-Mulk (67) — see assets/quran/audio/popular/README.md. Every
// other surah can be downloaded on demand instead
// (surah_audio_download_service.dart — this app's one deliberate,
// scoped exception to its offline-first rule, see CLAUDE.md). Once
// downloaded, playback is a local file, exactly as offline as the
// bundled assets from then on.

import 'package:audioplayers/audioplayers.dart';

import 'surah_audio_download_service.dart';

/// Individually curated surahs (outside Juz Amma) with a bundled
/// recording — commonly recited surahs, not a contiguous range like
/// Juz Amma.
const _curatedSurahIds = {18, 36, 55, 67};

/// `true` for surahs 78-114 (Juz Amma) or one of [_curatedSurahIds] —
/// bundled at build time, no download ever needed. Callers use this to
/// decide whether to show a plain play control (bundled) versus
/// checking download state (everything else).
bool hasBundledSurahAudio(int surahId) =>
    (surahId >= 78 && surahId <= 114) || _curatedSurahIds.contains(surahId);

/// Kept for existing call sites/tests — same meaning as
/// [hasBundledSurahAudio]. Prefer the more explicit name in new code,
/// since it's no longer the *only* way a surah can have audio.
bool hasSurahAudio(int surahId) => hasBundledSurahAudio(surahId);

String? surahAudioAsset(int surahId) {
  if (!hasBundledSurahAudio(surahId)) return null;
  final padded = surahId.toString().padLeft(3, '0');
  final folder = _curatedSurahIds.contains(surahId) ? 'popular' : 'juz_amma';
  return 'quran/audio/$folder/$padded.m4a';
}

/// Thin wrapper so callers (a screen, not a widget tree directly)
/// don't depend on the `audioplayers` package type.
class SurahAudioPlayer {
  SurahAudioPlayer({AudioPlayer? player, SurahAudioDownloadService? downloadService})
    : _player = player ?? AudioPlayer(),
      _downloadService = downloadService ?? const SurahAudioDownloadService();

  final AudioPlayer _player;
  final SurahAudioDownloadService _downloadService;

  Stream<void> get onComplete => _player.onPlayerComplete;

  /// Plays the recitation for [surahId] — a bundled asset if there is
  /// one, otherwise a previously downloaded local file, otherwise does
  /// nothing (the UI never offers a play control in that case; see
  /// SurahAudioButton). Stops any currently-playing clip first.
  Future<void> play(int surahId) async {
    final asset = surahAudioAsset(surahId);
    await _player.stop();
    if (asset != null) {
      await _player.play(AssetSource(asset));
      return;
    }
    final localPath = await _downloadService.localPathFor(surahId);
    if (localPath == null) return;
    await _player.play(DeviceFileSource(localPath));
  }

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
