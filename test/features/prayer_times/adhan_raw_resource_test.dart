// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/adhan_audio_player.dart';
import 'package:noor/features/prayer_times/data/adhan_reciter.dart';

void main() {
  test('doha has one sound per prayer; others one sound for all', () {
    expect(adhanRawResourceFor(AdhanReciter.doha, 'Fajr'), 'adhan_fajr');
    expect(adhanRawResourceFor(AdhanReciter.doha, 'Isha'), 'adhan_isha');
    expect(adhanRawResourceFor(AdhanReciter.indonesia, 'Asr'), 'adhan_indonesia');
    expect(adhanRawResourceFor(AdhanReciter.hamtramck, 'Maghrib'), 'adhan_hamtramck');
  });

  test('no adhan for Sunrise or unknown names', () {
    expect(adhanRawResourceFor(AdhanReciter.doha, 'Sunrise'), isNull);
    expect(adhanRawResourceFor(AdhanReciter.marrakech, 'Sunrise'), isNull);
    expect(hasAdhanForPrayer('Sunrise'), isFalse);
    expect(hasAdhanForPrayer('Dhuhr'), isTrue);
  });

  test('every mapped sound exists in res/raw (preview and notification share it)', () {
    for (final reciter in AdhanReciter.values) {
      for (final prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
        final name = adhanRawResourceFor(reciter, prayer)!;
        expect(File('android/app/src/main/res/raw/$name.mp3').existsSync(), isTrue, reason: name);
      }
    }
  });

  test('preview never throws without an Android side', () async {
    final player = AdhanAudioPlayer();
    await player.play('Fajr');
    await player.stop();
    await player.dispose();
  });
}
