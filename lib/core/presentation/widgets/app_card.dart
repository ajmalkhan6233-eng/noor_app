// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one card shape used everywhere: white on cream, 20px radius, a
// 1px hairline border, and a very soft shadow — paper lifted off the
// page, never a filled colour block.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
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
            border: Border.all(color: AppColors.hairline),
          ),
          child: child,
        ),
      ),
    );
  }
}
