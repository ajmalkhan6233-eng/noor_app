// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/surah_audio_player.dart';

void main() {
  group('hasSurahAudio', () {
    test('true for every surah in Juz Amma (78-114)', () {
      for (var id = 78; id <= 114; id++) {
        expect(hasSurahAudio(id), isTrue, reason: 'surah $id');
      }
    });

    test('true for each individually curated surah', () {
      for (final id in [18, 36, 55, 67]) {
        expect(hasSurahAudio(id), isTrue, reason: 'surah $id');
      }
    });

    test('false for surahs outside both Juz Amma and the curated set', () {
      for (final id in [1, 2, 17, 19, 35, 37, 54, 56, 66, 68, 77]) {
        expect(hasSurahAudio(id), isFalse, reason: 'surah $id');
      }
    });
  });

  group('surahAudioAsset', () {
    test('routes Juz Amma surahs to the juz_amma folder', () {
      expect(surahAudioAsset(78), 'quran/audio/juz_amma/078.m4a');
      expect(surahAudioAsset(114), 'quran/audio/juz_amma/114.m4a');
    });

    test('routes curated surahs to the popular folder', () {
      expect(surahAudioAsset(18), 'quran/audio/popular/018.m4a');
      expect(surahAudioAsset(36), 'quran/audio/popular/036.m4a');
      expect(surahAudioAsset(55), 'quran/audio/popular/055.m4a');
      expect(surahAudioAsset(67), 'quran/audio/popular/067.m4a');
    });

    test('null for anything without bundled audio', () {
      expect(surahAudioAsset(1), isNull);
      expect(surahAudioAsset(19), isNull);
      expect(surahAudioAsset(77), isNull);
    });
  });
}
