// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/constants/app_info.dart';

void main() {
  test('app_info.dart matches the version in pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(r'^version:\s*([0-9.]+)\+(\d+)', multiLine: true).firstMatch(pubspec);
    expect(match, isNotNull);
    expect(appVersionName, match!.group(1));
    expect(appBuildNumber, int.parse(match.group(2)!));
  });
}
