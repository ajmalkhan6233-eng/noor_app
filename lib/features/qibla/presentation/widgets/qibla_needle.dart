// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A confident-looking needle is only ever shown when the compass
// reading backing it is actually trustworthy — otherwise it's dimmed,
// never a fully-opaque, seemingly-reliable wrong arrow. Rendered as a
// physical object: a raised bezel, a recessed face, and a needle that
// casts its own shadow — see CompassFacePainter. The whole assembly
// tilts subtly with the accelerometer via a perspective transform.
// [dimmed]'s target alpha is eased in over ~350ms rather than applied
// instantly — a raw per-frame bool caused a visible flicker whenever
// the underlying accuracy classification jittered near its threshold.
import 'package:flutter/material.dart';

import '../../../../core/presentation/motion/motion.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'compass_face_painter.dart';

class QiblaNeedle extends StatefulWidget {
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
  State<QiblaNeedle> createState() => _QiblaNeedleState();
}

class _QiblaNeedleState extends State<QiblaNeedle> with SingleTickerProviderStateMixin {
  static const _trustworthyAlpha = 1.0;
  static const _dimmedAlpha = 0.35;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: widget.dimmed ? 0 : 1,
    );
  }

  @override
  void didUpdateWidget(QiblaNeedle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dimmed == oldWidget.dimmed) return;
    if (Motion.reduced(context)) {
      _controller.value = widget.dimmed ? 0 : 1;
    } else if (widget.dimmed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label =
        '${AppLocalizations.of(context)!.qiblaNeedleSemanticLabel}: '
        '${widget.rotationDegrees.round()} degrees from facing direction'
        '${widget.dimmed ? ', low confidence' : ''}';

    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0015)
      ..rotateX(widget.tiltY * 0.12)
      ..rotateY(-widget.tiltX * 0.12);

    return Semantics(
      label: label,
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: SizedBox(
          width: 272,
          height: 272,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: CompassFacePainter(
                rotationDegrees: widget.rotationDegrees,
                needleAlpha: _dimmedAlpha + (_trustworthyAlpha - _dimmedAlpha) * _controller.value,
                tiltX: widget.tiltX,
                tiltY: widget.tiltY,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
