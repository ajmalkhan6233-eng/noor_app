// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Today's done/5 ring. The arc fills smoothly as prayers are ticked
// (and from empty when first shown); reaching 5/5 plays a short, gentle
// celebration: the ring swells once and a few stars drift outward and
// fade. Built-in animations only; with reduced motion everything is
// instant. Optionally tappable (opens the day detail).

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/motion/motion.dart';
import '../../../../core/utils/semantics_helpers.dart';

class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.done,
    this.size = 96,
    this.semanticLabel,
    this.semanticHint,
    this.onTap,
  });

  final int done;
  final double size;
  final String? semanticLabel;
  final String? semanticHint;
  final VoidCallback? onTap;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing> with SingleTickerProviderStateMixin {
  late final AnimationController _celebration = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didUpdateWidget(ProgressRing old) {
    super.didUpdateWidget(old);
    if (old.done < 5 && widget.done >= 5 && !Motion.reduced(context)) {
      _celebration.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _celebration.dispose();
    super.dispose();
  }

  double get _fraction => (widget.done / 5).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ring = AnimatedBuilder(
      animation: _celebration,
      builder: (context, _) {
        final t = _celebration.value;
        final celebrating = _celebration.isAnimating;
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.scale(
              scale: 1 + 0.07 * math.sin(math.pi * t),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _fraction),
                  duration: Motion.effective(context, const Duration(milliseconds: 700)),
                  curve: Motion.curve,
                  builder: (context, value, _) => CustomPaint(
                    painter: _RingPainter(fraction: value, track: colors.hairline, arc: colors.gold),
                    child: Center(
                      child: Text(
                        '${widget.done}/5',
                        style: AppTypography.counter(colors.ink)
                            .copyWith(fontSize: AppTypography.timeLargeSize),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (celebrating) _Sparkles(key: const Key('progress-celebration'), t: t, size: widget.size),
          ],
        );
      },
    );

    final label = widget.semanticLabel;
    if (widget.onTap != null && label != null) {
      return SemanticButton(label: label, hint: widget.semanticHint, onTap: widget.onTap!, child: ring);
    }
    return Semantics(label: label, excludeSemantics: label != null, child: ring);
  }
}

/// Eight small stars drifting outward and fading as [t] goes 0 -> 1.
class _Sparkles extends StatelessWidget {
  const _Sparkles({super.key, required this.t, required this.size});

  final double t;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.gold;
    final radius = size / 2 + 2 + 18 * t;
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < 8; i++)
              Positioned(
                left: size / 2 + radius * math.cos(i * math.pi / 4) - 6,
                top: size / 2 + radius * math.sin(i * math.pi / 4) - 6,
                child: Opacity(
                  opacity: (1 - t).clamp(0.0, 1.0),
                  child: Icon(Icons.star_rounded, size: 12, color: color),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.fraction, required this.track, required this.arc});

  final double fraction;
  final Color track;
  final Color arc;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 9.0;
    final arcRect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, paint..color = track);
    if (fraction > 0) {
      canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2 * fraction, false, paint..color = arc);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.track != track || old.arc != arc;
}
