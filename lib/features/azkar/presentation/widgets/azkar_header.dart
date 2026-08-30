// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Large centered screen title, added 2026-08-30 (master directive
// item 8: "large, centered, alive header" instead of the plain AppBar
// title this screen had). Reuses [AppTypography.heroDisplay] — the
// same display style already used for the next-prayer name — so this
// reads as the same visual language as the rest of the app rather
// than a one-off treatment. "Alive" here means it enters with the
// same [StaggeredFadeIn] motion as the rest of the screen (added at
// the call site) plus a slow, subtle breathing glow behind the title
// — no new animation system, just the existing gold glow pattern used
// elsewhere (e.g. the Tasbih milestone button) slowed down for an
// ambient rather than a reactive moment.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';

class AzkarHeader extends StatefulWidget {
  const AzkarHeader({super.key, required this.title});

  final String title;

  @override
  State<AzkarHeader> createState() => _AzkarHeaderState();
}

class _AzkarHeaderState extends State<AzkarHeader> with SingleTickerProviderStateMixin {
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
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final glowAlpha = 0.15 + _glowController.value * 0.15;
            return DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: colors.gold.withValues(alpha: glowAlpha),
                    blurRadius: 40,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Text(widget.title, style: AppTypography.heroDisplay(colors.ink)),
        ),
      ),
    );
  }
}
