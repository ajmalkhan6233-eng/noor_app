// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/widgets.dart';

import 'app_color_tokens.dart';

extension ThemedCornerRadius on BuildContext {
  /// The rounded radius the design asks for ([normal]) — or the active
  /// theme's own corner radius when it is a flat theme (Mushaf: square).
  double radiusFor(double normal) {
    final tokens = colors;
    return tokens.flatSurfaces ? tokens.cornerRadius : normal;
  }
}
