// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/database/restored_data_guard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<int> run(Map<String, Object> initial) async {
    SharedPreferences.setMockInitialValues(initial);
    final prefs = await SharedPreferences.getInstance();
    var wipes = 0;
    await runRestoredDataGuard(prefs, wipe: () async => wipes++);
    expect(prefs.getBool(restoredDataGuardKey), isTrue);
    return wipes;
  }

  test('fresh install (empty prefs) wipes restored tracker data once', () async {
    expect(await run({}), 1);
  });

  test('app update (prefs already exist) keeps user data', () async {
    expect(await run({'onboarding_done': true}), 0);
  });

  test('guard already ran: nothing happens', () async {
    expect(await run({restoredDataGuardKey: true}), 0);
  });

  test('wipe failure does not set the flag, so it retries next launch', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await runRestoredDataGuard(prefs, wipe: () async => throw StateError('db'));
    expect(prefs.getBool(restoredDataGuardKey), isNull);
  });

  test('looksLikeFreshInstall is pure', () {
    expect(looksLikeFreshInstall(guardAlreadyRan: false, preferenceKeys: {}), isTrue);
    expect(looksLikeFreshInstall(guardAlreadyRan: false, preferenceKeys: {'a'}), isFalse);
    expect(looksLikeFreshInstall(guardAlreadyRan: true, preferenceKeys: {}), isFalse);
  });
}
