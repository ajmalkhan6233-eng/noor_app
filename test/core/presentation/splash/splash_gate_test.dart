// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/presentation/splash/splash_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SplashGate gate;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    gate = SplashGate();
  });

  test('shows the splash on a genuinely first launch', () async {
    expect(await gate.shouldShowSplash(), isTrue);
  });

  test('skips the splash on a reopen shortly after the last one', () async {
    await gate.markSplashShown();
    expect(await gate.shouldShowSplash(), isFalse);
  });

  test('shows the splash again once the inactivity threshold has passed', () async {
    final prefs = await SharedPreferences.getInstance();
    final staleTime = DateTime.now().subtract(
      SplashGate.inactivityThreshold + const Duration(minutes: 1),
    );
    await prefs.setInt(
      'splash_last_shown_at_millis',
      staleTime.millisecondsSinceEpoch,
    );

    expect(await gate.shouldShowSplash(), isTrue);
  });
}
