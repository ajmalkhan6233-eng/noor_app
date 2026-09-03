// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Uses a real temp directory (via a fake PathProviderPlatform) and a
// mocked http client — proves the actual file-write/rename/delete
// logic works, not just that the network call shape looks right.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:noor/features/quran/data/surah_audio_download_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProvider(this.dir);
  final Directory dir;

  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('noor_audio_test_');
    PathProviderPlatform.instance = _FakePathProvider(tempDir);
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  test('isDownloaded is false before any download', () async {
    const service = SurahAudioDownloadService();
    expect(await service.isDownloaded(18), isFalse);
    expect(await service.localPathFor(18), isNull);
  });

  test('download saves the file and isDownloaded becomes true', () async {
    final bytes = Uint8List.fromList(List.generate(1000, (i) => i % 256));
    final client = MockClient.streaming((request, bodyStream) async {
      return http.StreamedResponse(Stream.value(bytes), 200, contentLength: bytes.length);
    });
    final service = SurahAudioDownloadService(client: client);

    final progressEvents = <SurahDownloadProgress>[];
    await for (final progress in service.download(18)) {
      progressEvents.add(progress);
    }

    expect(progressEvents, isNotEmpty);
    expect(progressEvents.last.receivedBytes, bytes.length);
    expect(await service.isDownloaded(18), isTrue);
    final path = await service.localPathFor(18);
    expect(path, isNotNull);
    expect(await File(path!).readAsBytes(), bytes);
  });

  test('a non-200 response throws SurahDownloadFailure and leaves no file', () async {
    final client = MockClient.streaming((request, bodyStream) async {
      return http.StreamedResponse(const Stream.empty(), 404);
    });
    final service = SurahAudioDownloadService(client: client);

    await expectLater(
      service.download(18).toList(),
      throwsA(isA<SurahDownloadFailure>()),
    );
    expect(await service.isDownloaded(18), isFalse);
  });

  test('totalBytesUsed and downloadedCount reflect downloaded files', () async {
    final bytes = Uint8List.fromList(List.filled(500, 7));
    final client = MockClient.streaming((request, bodyStream) async {
      return http.StreamedResponse(Stream.value(bytes), 200, contentLength: bytes.length);
    });
    final service = SurahAudioDownloadService(client: client);

    await service.download(18).drain<void>();
    await service.download(36).drain<void>();

    expect(await service.downloadedCount(), 2);
    expect(await service.totalBytesUsed(), 1000);

    await service.deleteAll();
    expect(await service.downloadedCount(), 0);
    expect(await service.totalBytesUsed(), 0);
  });
}
