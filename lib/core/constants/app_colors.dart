import 'package:flutter/material.dart';

/// Noor design tokens.
///
/// Base palette stays Deep Emerald / Metallic Gold (the established
/// brand identity). The "glass" / "glow" tokens below let widgets
/// achieve a cosmic, tactile feel — blurred glass panels, glowing
/// borders, particle-like shockwaves — natively in Flutter, without
/// pulling in any web-only library. Do not hardcode hex values
/// elsewhere; reference these constants.
class AppColors {
  AppColors._();

  // Core surfaces
  static const Color background = Color(0xFF0A1912);
  static const Color cardSurface = Color(0xFF132A20);
  static const Color gold = Color(0xFFD4AF37);

  // Glass / glow accent layer (HUD overlays, milestone pulses,
  // tactile feedback states). Layered on top of the emerald base.
  static const Color glassBorder = Color(0x33D4AF37); // 20% gold stroke
  static const Color glowSoft = Color(0x1AD4AF37); // 10% gold glow
  static const Color glowMilestone = Color(0x8CD4AF37); // 55% gold glow

  // Semantic text
  static const Color textPrimary = Color(0xFFF5EEDC);
  static const Color textSecondary = Color(0xFFB8C9BE);
  static const Color hudText = Color(0xFFF5EEDC);
}
