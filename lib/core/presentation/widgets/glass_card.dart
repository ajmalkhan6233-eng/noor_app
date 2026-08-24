// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A real frosted-glass card (BackdropFilter blur), separate from
// AppCard on purpose — see AppCard's own header comment for the
// history: wiring a BackdropFilter version into AppCard (used
// everywhere) broke Home/More tab rendering in CI three times when
// combined with CosmicBackground and the nav-dock restructure, with
// no local Flutter available at the time to find out why. This is an
// isolated, opt-in widget instead: nothing existing uses it, so it
// can be dropped into one screen at a time, verified live on a real
// device, and only wired in more broadly once actually confirmed
// safe — not swapped in everywhere at once like last time.

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.55),
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.hairline, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
