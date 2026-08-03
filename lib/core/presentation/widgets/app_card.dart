// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one card shape used everywhere: card fill, 16px radius, a 1px
// hairline border, no Material elevation shadow.

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
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: child,
    );
  }
}
