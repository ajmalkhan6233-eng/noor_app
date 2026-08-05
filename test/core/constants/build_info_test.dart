// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/build_info.dart';

void main() {
  group('BuildInfo', () {
    test('falls back to dev/0 with no dart-defines (a local/test build)', () {
      expect(BuildInfo.commitSha, 'dev');
      expect(BuildInfo.buildNumber, '0');
    });

    test('label format is "Build <sha> · #<number>"', () {
      expect(BuildInfo.label, 'Build ${BuildInfo.commitSha} · #${BuildInfo.buildNumber}');
    });
  });
}
