// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A confident-looking needle is only ever shown when the compass
// reading backing it is actually trustworthy — otherwise it's dimmed,
// never a fully-opaque, seemingly-reliable wrong arrow. Rendered as a
// physical object: a raised bezel, a recessed face, and a needle that
// casts its own shadow — see CompassFacePainter.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import 'compass_face_painter.dart';

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
      child: SizedBox(
        width: 220,
        height: 220,
        child: CustomPaint(
          painter: CompassFacePainter(
            rotationDegrees: rotationDegrees,
            dimmed: dimmed,
          ),
        ),
      ),
    );
  }
}
