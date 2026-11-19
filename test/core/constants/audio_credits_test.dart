// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/audio_credits.dart';

void main() {
  test('every bundled adhan file with a CC BY licence is credited', () {
    final credited = adhanCredits.map((c) => c.line).join('\n');
    expect(credited, contains('RTB45'));
    expect(credited, contains('iainmccurdy'));
    expect(credited, contains('RJStefanski'));
    expect(credited, contains('CC BY 4.0'));
    expect(credited, contains('CC BY 3.0'));
  });

  test('every credited file exists as an Android res/raw sound', () {
    for (final c in adhanCredits) {
      expect(File('android/app/src/main/res/raw/adhan_${c.file}').existsSync(), isTrue,
          reason: '${c.file} is credited but not bundled');
    }
  });
}
