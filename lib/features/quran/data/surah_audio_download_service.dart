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
//
// INTEGRITY: every download is verified against a hardcoded SHA-256
// hash before the file is accepted. If the hash doesn't match, the
// file is deleted and a failure is reported — same pattern as the
// Azkar and other asset integrity checks in this app.

import 'dart:io';

import 'package:crypto/crypto.dart';
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

/// Expected SHA-256 hashes (lowercase hex) for every downloadable surah.
/// These were computed from the real files at the archive.org source on
/// 2026-09-07 and match the Moeed Alharthi / Hafs / Dhikr Al-Huda
/// murattal/32 (32kbps M4A) collection — the same source used for
/// bundled audio.
///
/// Bundled surahs (18, 36, 55, 67, 78–114) are NOT in this map — they
/// are verified separately via the asset pipeline.
///
/// If the source ever re-encodes or replaces a file, its hash here will
/// no longer match and downloads will fail with an integrity error. In
/// that case: re-fetch, re-compute, and update this map.
const Map<int, String> _expectedSha256 = {
  1: 'f196b1da5b1763eff03a502ac6549ba6d99393d2243f293938042a6b10a68799',
  2: '58e97c2128bcd3a927a4392b1a527e82a641afe78971c05f119472e7fd0c8ce0',
  3: '417cb65f7276f164fcb013bb43e684adee515cb7e349da922a857e8989eef4c4',
  4: 'affceb05a1258062da70f283c379694649a15f194b3e32d3784130b67ef80951',
  5: 'bffcecc5c9bee77622bc28d27f2f1ce1ad97b9f7060879b5aaf32a941380c819',
  6: '5f05c7f6ffa10a8cad92d302961f9c344f8a189be2ce318ddce30a9377f771a8',
  7: '793110ea6992f6c654d893297f0badb90c40462c0f789f0502ac288faead0506',
  8: 'c015c64ca7d1b6aa90b7799b50f51943b053168e8cf3aa2a13d101e1ad30da81',
  9: 'b8c1a0c5f5aad6ac757545728fbbe2eaa2ad4d4af509ab4b89c1993351c5da33',
  10: '7e5549ee68368c359f238a5c47e63ba101e7ccc8bd2f3a62e0676b7b8c4d5d78',
  11: '7abfcbf42976d184d73c5593b5a034385c312d8c01cf7198c4ad6b07ae17dfa7',
  12: '3867a71032d12f76104ff538c2318a08eee08e6dc8e48cba989a789aaff8b554',
  13: '20421d3af769a2515f92bce6cddf92d0eb04c2023262154f3c2d7e464be505f6',
  14: 'b01f2e6b6b80a9071577ad49b2c7351b1d3c4a71fd3cf0cdc9a6749b7c373a6b',
  15: '306d7fad12f476647658a95f6a71636002db32bed3d1d0a4c7e5d76b0b151714',
  16: 'b57b7bcde787f2b04e42ff0af1fa13f28335fcfd1dc5972c288df7ccadf8dbff',
  17: '8b3e45eeef55aa2ba2be17f069523459b77589987d62ad724f386bffedb56b9f',
  19: '24d689e300ea6d90dce22b4e0b6e7315106c83f52d3742e1062fd3cc18cbd3fb',
  20: 'd37852507606e5c58b30da55d3ec71ce1932fea0492592aea306d663d9d3d601',
  21: '2df656c4fecd3f522dff1d5009eaa27b936421ad26c2c72d2c2e4b25c95af6b1',
  22: '3ca274aa9d39f8349656a4b57a2cf63f3b9ee1b02aee4927d9adea9842a91cd3',
  23: '436df7ded5be05afc642c74150b04a71c2e34650b9d33d05ff59a3ead18c3f05',
  24: 'a6b74d05d871b7518768dd959dff0be339abd7ef05a0a2785804059c442812b7',
  25: '44c6abde4c4fc2782920f3c661a9229cfa4260b5327ea30ff8dc92d0f8980f38',
  26: '090f0f143e5854ca1af96c9635c83f519c0eb98b7f5b52310f7ab6873da935fc',
  27: '02d3c452040f4258e9b5ea9f5838d7856aad7d3aa72e35496d537423f1229b98',
  28: '7ca0786489ed47503c3912dcb9e4371125a6cc64bb96f905e6a1554832982bc2',
  29: '551e66d1b93f679891c8d53d58fa0a06479c4b0a06d6311d32f08f1cccd33270',
  30: 'edd1809ecae70bd38b3a20155deb27abab8d241514b04c49162a7984f9eddd1d',
  31: 'ee6d9d8458ca450745c854ee32d10df1627f4781cfd36e03e972752c94d215be',
  32: '78b0156ae05cc354142ff999bc5683dfc37574bde57c721fd5c4f331aa253835',
  33: 'f0f07c8404abd2f38443425b04ded070d55b4d3f37515a7d67714894bcfcbad7',
  34: '0c7d43492d15d86fe5b4970f074dd630e1f1751f69539e04c2091f5169b4bf28',
  35: '3201d8c5293967b7f94926dac43539356ebd6eb331e31d6bcdf2d2a16216c2d0',
  37: '90faac2f58ab11aeee43662b2bb8446a872d039006a975c344e166b8a6467a85',
  38: 'dbaa2e812cf608a3d523055c5f51b109f29a0f3296654b510b42c36c5ea71618',
  39: '8a7b32620e700d6fcdcf1437ad7d449f8aa122e2e43ece6862cd472d6275ef92',
  40: '011839cbb7c2912b47cca3a9a27be0b77b81eb7996d9a93400ef27c97aff8cdb',
  41: '77e06f9f7e5acc51cf96f577d0234d10670960e487fdd364124f68422a8e689e',
  42: 'e3a987ab0998f3f22a938be095bdd6c99c6ec76f2b10a3eff50d475b407beed5',
  43: '043ccc135b2c9e1f4a6755de7c9bf4a8dfc259ef848c10de545f3be3371ee71f',
  44: '2a4932334eb2291e709dba920c99bcb5a1366da1d6131a8eed0c91b3b04213ec',
  45: '635ba84ee11b8a95fda0ff2606c497e2313fa796e3e9d26148c22a0946763bde',
  46: '83550f3cc0bd673241f54847a81ecfd608572c58f4324e4bafcaa47ccaacf728',
  47: 'ce112ab236e558e3f2278b10295475fbaabbe94cb90fa6c929172c561d31e697',
  48: 'f08445aeeb3193f3edfb47c376e2cd5298f8b17f9cad76030d014b89a3397af1',
  49: 'bf2e07d9692808bb9038288746c1c43b8206aeb3cd7090e5fbc829dea453d531',
  50: '87e3c2e1a72d88056cfcffeedbc401d4392c7eb493a2c7aaafd1b7f0a0ab373d',
  51: 'eecff71d2ec28f697efa83ccff752149ddb9c344de00387939de03f64b5795c6',
  52: 'efffb73a3c62a37c92c5cc9fe3735d3cd176f6e0dafd553575a3cdb6bcfae02e',
  53: '372f63884449b7045dc18097e57c3a9380c4f604ea1231db5535a993b325c1b0',
  54: '017247bc7a8fd566662a7f72ae5433314b3385b055b3b3288a51daeed316b4e8',
  56: '5dd4d2342af009e8112f624d33c98f7710418c390cc392c0c8c6549b5a89cb94',
  57: '954dcb580c10261d0e8059309ac7817d530adedc7f02a248ab14bb9c94900123',
  58: 'a3010af5a11463fcd7ff9edb08d9a66f5fb87e7e54126996c20df442f41129da',
  59: '708e1d2ef7f2323165df0f6579a36f8842522621e2438f8c07d790045f08b5f7',
  60: 'c1de9e1867d6fe85275e88bc3dba756b3985b9b66a9f724c520a81fe7a0597ed',
  61: '9db79fd2994e34ee958cdaf960cd818d0fec9b5ae823c03e68a3ee52d70593cd',
  62: '4ac6152333acaf72242c9a3c0642a5486c3fe340779fa25e262224e61d452dbe',
  63: '29af304fb714f7b01f5e83d343770c185149569e7db6b2cd0ac89974685290b4',
  64: '7e16b2cf3b9e2c1bfedee98f113e72473f51714f017f077e1645a6c5f7ad7d0f',
  65: '7faa1df40c330039d2cc03ebc31b868fe383dd0ad3dec5d29977766dc9d169a8',
  66: '4942872e7334f73614155f9b33d85e7d3a6ed4e009fe5dd4c8cb413893a9c02b',
  68: 'e437759d544355f54a877fc92dac1c2fb75ef0c64876ae6eb1211e76a180c5a5',
  69: 'e79bbeaec050d5ea227b1f2bc3ea63d18ae698013707598df0f05a13ca1fe88c',
  70: '17e26b6162fb61df9ad71994359258487551e78db0f581627ffb4368f3b3d17a',
  71: 'd877cc9a0a206ade4d0f6ce0a477bf38a808a729fb21e0941d9a7181105b5d22',
  72: 'ed6d007c7dfa1ed1e5f227d080d0dd9b671e46f3c64f9de86445efc494ba1a55',
  73: 'de99618564499b8ecc0258a2cf26b3f3d8acd87245638d2538230ec75c5effed',
  74: '88a14905330541b54857d8c09e3b0b72417affa63f0c4190b6d6d398fb62d0ac',
  75: '80e151c3133c3a76e503cda35725622717315767ecaf411d0c8be5dedb12df7e',
  76: '032d115bfd474efadc315ab9158cd5dd79fafd7f34a9637fbe24cb6769b3e34b',
  77: '48b209140fca9e3282da2457f587f392a2208eed037cc83b2869d9b30411273f',
};

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
  /// arrives. Throws [SurahDownloadFailure] on any network error, a
  /// non-200 response, or a SHA-256 integrity mismatch — callers must
  /// show this, not swallow it. Writes to a `.part` temp file first
  /// and verifies the hash before renaming to the final path, so a
  /// failed/interrupted/tampered download never leaves a corrupt file
  /// behind that `isDownloaded` would wrongly report as complete.
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

      // Compute SHA-256 over the fully written part file.
      final bytes = await partFile.readAsBytes();
      final digest = sha256.convert(bytes);
      final actualHex = digest.toString();

      final expectedHex = _expectedSha256[surahId];
      if (expectedHex != null && actualHex != expectedHex) {
        // Delete the bad file immediately — don't leave anything corrupt.
        await partFile.delete();
        throw SurahDownloadFailure(
          'Integrity check failed for surah $surahId — '
          'the downloaded file did not match the expected checksum. '
          'Please try again; if this keeps happening, the source file '
          'may have changed.',
        );
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
