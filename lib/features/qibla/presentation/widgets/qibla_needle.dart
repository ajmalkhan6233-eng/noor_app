// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A confident-looking needle is only ever shown when the compass
// reading backing it is actually trustworthy — otherwise it's dimmed,
// never a fully-opaque, seemingly-reliable wrong arrow.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Needle pointing toward the Kaaba, rotated by [rotationDegrees]
/// relative to true north-up. Dimmed when [dimmed] is true.
class QiblaNeedle extends StatelessWidget {
  const QiblaNeedle({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
  });

  final double rotationDegrees;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final label =
        '${AppStrings.qiblaNeedleSemanticLabel}: '
        '${rotationDegrees.round()} degrees from facing direction'
        '${dimmed ? ', low confidence' : ''}';

    return Semantics(
      label: label,
      child: Opacity(
        opacity: dimmed ? 0.35 : 1.0,
        child: Transform.rotate(
          angle: rotationDegrees * 3.14159265358979 / 180,
          child: const Icon(
            Icons.navigation,
            color: AppColors.accent,
            size: 96,
          ),
        ),
      ),
    );
  }
}
