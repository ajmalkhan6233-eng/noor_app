// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one card shape used everywhere: card surface on near-black,
// 20px radius, a 1px hairline border (cyan by default), and a soft
// shadow — never a flat filled block. Featured cards can pass
// [borderColor]/[glowColor] (e.g. gold) per the locked palette's
// "gold border on featured/dua cards" rule — plain cards leave both
// null and get the ordinary cyan hairline with no glow.
//
// NOTE: a BackdropFilter-based real glass-blur version of this was
// tried and reverted in the same session — it (or something entangled
// with it) broke Home tab rendering in CI (HeroCard, which every
// card-using widget depends on, stopped being found by 3 different
// widget tests, reproducibly). No working local Flutter install on
// this machine to confirm BackdropFilter specifically was the cause
// vs. something else in that same commit, so flagging rather than
// re-attempting blind: BackdropFilter is a known source of rendering
// pipeline issues under flutter_test specifically (as opposed to a
// real device), which is a plausible explanation. Revisit with local
// Flutter tooling available to verify against a real device/golden
// render, not just CI's headless test run.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderColor,
    this.glowColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Border colour override — defaults to [AppColors.hairline].
  final Color? borderColor;

  /// When set, adds a soft coloured glow behind the card (e.g.
  /// [AppColors.gold] for a streak capsule, [AppColors.accentSecondary]
  /// for a countdown capsule).
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.paper.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          if (glowColor != null)
            BoxShadow(
              color: glowColor!.withValues(alpha: 0.35),
              blurRadius: 20,
              spreadRadius: 1,
            ),
        ],
      ),
      // A dedicated Material — rather than relying on a distant
      // ancestor — so any ListTile/InkWell/etc. inside the card paints
      // its ink effects here, not hidden beneath the shadow's
      // DecoratedBox.
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor ?? AppColors.hairline),
          ),
          child: child,
        ),
      ),
    );
  }
}
