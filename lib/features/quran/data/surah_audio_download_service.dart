// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// This app's one and only network-capable feature. Everything else in
// noor is offline-first with zero network calls, by design (see
// CLAUDE.md's Non-Negotiable Architecture section) — this file is the
// single deliberate, scoped exception: optional, user-initiated Quran
// audio downloads for surahs outside the bundled Juz Amma/curated set.
// Every download is triggered by an explicit tap on a download icon,
// never automatic, never on app start, never in the background.
//
// Same source, reciter, and licence already verified for the bundled
// audio (see assets/quran/audio/juz_amma/README.md and
// assets/quran/audio/popular/README.md): Moeed Alharthi, Hafs
// narration, Dhikr Al-Huda collection on Internet Archive, CC BY 4.0,
// the murattal/32/ (32kbps M4A) directory — for consistency across the
// whole Quran, not a different reciter for downloaded surahs.
//
// Downloaded files are saved to this app's own local files directory
// (path_provider's application-support directory), never the bundled
// assets folder — once downloaded, playback is exactly as offline as
// the bundled files, no re-fetch on replay.

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// One reported progress step during a download — `receivedBytes` and
/// `totalBytes` are both known up front (the source always reports
/// Content-Length), so progress is exact, not estimated.
class SurahDownloadProgress {
  const SurahDownloadProgress(this.receivedBytes, this.totalBytes);
  final int receivedBytes;
  final int? totalBytes;
  double? get fraction => totalBytes == null ? null : receivedBytes / totalBytes!;
}

class SurahDownloadFailure implements Exception {
  const SurahDownloadFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class SurahAudioDownloadService {
  const SurahAudioDownloadService({http.Client? client}) : _client = client;

  final http.Client? _client;

  static const _sourceBase =
      'https://archive.org/download/dhikr-alhuda-moeed-alharthi-hafs/murattal/32';

  Future<Directory> _audioDir() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory('${support.path}/downloaded_quran_audio');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> _fileFor(int surahId) async {
    final dir = await _audioDir();
    final padded = surahId.toString().padLeft(3, '0');
    return File('${dir.path}/$padded.m4a');
  }

  /// `true` once a surah has been downloaded and saved locally —
  /// plays fully offline from here on, same as a bundled asset.
  Future<bool> isDownloaded(int surahId) async {
    final file = await _fileFor(surahId);
    return file.exists();
  }

  /// Local file path for a previously downloaded surah, or `null` if
  /// it hasn't been downloaded (or was deleted).
  Future<String?> localPathFor(int surahId) async {
    final file = await _fileFor(surahId);
    return await file.exists() ? file.path : null;
  }

  /// Downloads surah [surahId]'s audio, emitting progress as it
  /// arrives. Throws [SurahDownloadFailure] on any network error or a
  /// non-200 response — callers must show this, not swallow it, per
  /// this feature's own "don't fail silently" requirement. Writes to a
  /// `.part` temp file first and only renames to the final path once
  /// the download completes fully, so a failed/interrupted download
  /// never leaves a corrupt file behind that `isDownloaded` would
  /// wrongly report as complete.
  Stream<SurahDownloadProgress> download(int surahId) async* {
    final client = _client ?? http.Client();
    final padded = surahId.toString().padLeft(3, '0');
    final uri = Uri.parse('$_sourceBase/$padded.m4a');
    final finalFile = await _fileFor(surahId);
    final partFile = File('${finalFile.path}.part');

    try {
      final request = http.Request('GET', uri);
      final http.StreamedResponse response;
      try {
        response = await client.send(request);
      } on Exception {
        throw const SurahDownloadFailure(
          'No internet connection — could not reach the download server.',
        );
      }

      if (response.statusCode != 200) {
        throw SurahDownloadFailure(
          'Download failed (server returned ${response.statusCode}).',
        );
      }

      final sink = partFile.openWrite();
      var received = 0;
      try {
        await for (final chunk in response.stream) {
          sink.add(chunk);
          received += chunk.length;
          yield SurahDownloadProgress(received, response.contentLength);
        }
      } finally {
        await sink.close();
      }

      if (response.contentLength != null && received != response.contentLength) {
        throw const SurahDownloadFailure('Download was interrupted before it finished.');
      }

      await partFile.rename(finalFile.path);
    } finally {
      if (_client == null) client.close();
      if (await partFile.exists()) await partFile.delete();
    }
  }

  /// Total bytes used by every downloaded surah — for the "Downloaded
  /// audio" storage section.
  Future<int> totalBytesUsed() async {
    final dir = await _audioDir();
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.m4a')) {
        total += await entity.length();
      }
    }
    return total;
  }

  /// How many surahs currently have a downloaded file.
  Future<int> downloadedCount() async {
    final dir = await _audioDir();
    if (!await dir.exists()) return 0;
    var count = 0;
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.m4a')) count++;
    }
    return count;
  }

  /// Deletes every downloaded surah's audio, freeing the space back
  /// up. Bundled (asset) audio is untouched — this only ever removes
  /// what this service itself downloaded.
  Future<void> deleteAll() async {
    final dir = await _audioDir();
    if (!await dir.exists()) return;
    await for (final entity in dir.list()) {
      if (entity is File) await entity.delete();
    }
  }
}
