// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'core/constants/app_color_tokens.dart';
import 'core/presentation/splash/splash_gate.dart';

/// Shown for the brief gap before [SplashGate] answers whether this
/// open should replay the intro — a blank obsidian screen rather than
/// any flash of the wrong choice (splash content, or the dashboard).
class SplashDecisionPlaceholder extends StatelessWidget {
  const SplashDecisionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: context.colors.paper);
  }
}
