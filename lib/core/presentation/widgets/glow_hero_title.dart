// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Large, theme-aware hero-style title text with a slow, subtle
// "breathing" glow behind it — the shared "alive" screen-title
// treatment (Azkar, Prayer Times) instead of a plain static title.
// No new animation system: reuses [AppTypography.heroDisplay] plus
// the same gold glow pattern already used elsewhere (e.g. the Tasbih
// milestone button), just slowed down for an ambient rather than a
// reactive moment. Extracted from AzkarHeader (2026-08-30) so this
// exact visual language can be reused without duplicating the
// animation controller.

import 'package:flutter/material.dart';
import '../../constants/app_typography.dart';

class GlowHeroTitle extends StatefulWidget {
  const GlowHeroTitle(this.text, {super.key, required this.color, this.style});

  final String text;
  final Color color;

  /// Overrides the default [AppTypography.heroDisplay] style — e.g.
  /// to add a `fontWeight` while keeping the same color and glow.
  final TextStyle? style;

  @override
  State<GlowHeroTitle> createState() => _GlowHeroTitleState();
}

class _GlowHeroTitleState extends State<GlowHeroTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowAlpha = 0.15 + _glowController.value * 0.15;
        return DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: glowAlpha),
                blurRadius: 40,
                spreadRadius: 6,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Text(widget.text, style: widget.style ?? AppTypography.heroDisplay(widget.color)),
    );
  }
}
