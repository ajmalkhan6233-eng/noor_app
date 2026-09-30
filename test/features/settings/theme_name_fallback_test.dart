// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/settings/data/app_theme_mode.dart';

void main() {
  test('known theme names round-trip', () {
    for (final option in AppThemeModeOption.values) {
      expect(appThemeModeFromName(option.name), option);
    }
  });

  test('an unknown or missing stored theme falls back to Nebula instead of throwing', () {
    expect(appThemeModeFromName('someFutureTheme'), AppThemeModeOption.dark);
    expect(appThemeModeFromName(null), AppThemeModeOption.dark);
  });
}
