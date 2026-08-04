// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A confident-looking needle is only ever shown when the compass
// reading backing it is actually trustworthy — otherwise it's dimmed,
// never a fully-opaque, seemingly-reliable wrong arrow. Rendered as a
// physical object: a raised bezel, a recessed face, and a needle that
// casts its own shadow — see CompassFacePainter. The whole assembly
// tilts subtly with the accelerometer via a perspective transform.
import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import 'compass_face_painter.dart';

class QiblaNeedle extends StatelessWidget {
  const QiblaNeedle({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
    this.tiltX = 0,
    this.tiltY = 0,
  });

  final double rotationDegrees;
  final bool dimmed;
  final double tiltX;
  final double tiltY;

  @override
  Widget build(BuildContext context) {
    final label =
        '${AppLocalizations.of(context)!.qiblaNeedleSemanticLabel}: '
        '${rotationDegrees.round()} degrees from facing direction'
        '${dimmed ? ', low confidence' : ''}';

    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0015)
      ..rotateX(tiltY * 0.12)
      ..rotateY(-tiltX * 0.12);

    return Semantics(
      label: label,
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: SizedBox(
          width: 220,
          height: 220,
          child: CustomPaint(
            painter: CompassFacePainter(
              rotationDegrees: rotationDegrees,
              dimmed: dimmed,
              tiltX: tiltX,
              tiltY: tiltY,
            ),
          ),
        ),
      ),
    );
  }
}
