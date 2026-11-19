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

  int? _preparedSurahId;

  /// Loads [surahId]'s recitation into the player ahead of time, so a
  /// later [play] starts at once instead of copying/decoding the file
  /// on tap (2026-11-19 audit: the cold path took up to ~2 s). Returns
  /// false when this surah has no audio here (not bundled, not yet
  /// downloaded). ReleaseMode.stop keeps the source loaded after a stop
  /// or when the recitation ends, so playing again is instant too.
  Future<bool> prepare(int surahId) async {
    final source = await _sourceFor(surahId);
    if (source == null) return false;
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setSource(source);
    _preparedSurahId = surahId;
    return true;
  }

  /// Plays the recitation for [surahId] — a bundled asset if there is
  /// one, otherwise a previously downloaded local file, otherwise does
  /// nothing (the UI never offers a play control in that case; see
  /// SurahAudioButton). Uses the prepared source when there is one.
  Future<void> play(int surahId) async {
    if (_preparedSurahId != surahId && !await prepare(surahId)) return;
    await _player.resume();
  }

  /// Plays [surahId] starting at [start] (an ayah's position, see
  /// ayah_timings.dart). Same prepared source as [play], so it is
  /// instant too.
  Future<void> playFrom(int surahId, Duration start) async {
    if (_preparedSurahId != surahId && !await prepare(surahId)) return;
    await _player.seek(start);
    await _player.resume();
  }

  Future<Source?> _sourceFor(int surahId) async {
    final asset = surahAudioAsset(surahId);
    if (asset != null) return AssetSource(asset);
    final localPath = await _downloadService.localPathFor(surahId);
    return localPath == null ? null : DeviceFileSource(localPath);
  }

  Future<void> stop() => _player.stop();

  Future<void> dispose() => _player.dispose();
}
