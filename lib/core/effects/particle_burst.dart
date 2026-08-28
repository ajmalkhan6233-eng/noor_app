// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A brief, restrained particle burst usable from anywhere in the app
// via a single call: ParticleBurst.play(context). Inserts a
// self-removing overlay entry centred on the calling widget, so
// callers never manage a controller or dispose anything themselves.
// Respects reduced motion — plays nothing at all rather than an
// instant flash, since a burst has no meaningful "settled" end state.

import 'package:flutter/material.dart';

import '../constants/app_color_tokens.dart';
import 'particle_burst_painter.dart';
import '../presentation/motion/motion.dart';

abstract final class ParticleBurst {
  /// Plays a particle burst centred on [context]'s render box (or
  /// [anchor], if given, in global coordinates). No-op under reduced
  /// motion. [intensity] (0–1) scales particle count and travel
  /// distance — use a small value for a calm confirmation, near 1 for
  /// a fuller celebratory moment.
  static void play(
    BuildContext context, {
    double intensity = 1.0,
    Offset? anchor,
    Color color = const Color(0xFFFFB703),
  }) {
    if (Motion.reduced(context)) return;

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    final center = anchor ?? _centerOf(context);
    if (center == null) return;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ParticleBurstOverlay(
        center: center,
        intensity: intensity.clamp(0.0, 1.0),
        color: color,
        onComplete: () => entry.remove(),
      ),
    );
    // Every caller triggers this from didUpdateWidget (Tasbih orb,
    // Qibla compass, Azkar counter, streak milestones — see their own
    // skill files) which runs during Flutter's build phase.
    // overlay.insert() calls setState() on the OverlayState
    // synchronously, and if that Overlay ancestor is itself mid-build
    // in the same frame (routine when a BlocBuilder rebuild cascades
    // down to this widget), that trips "setState() or markNeedsBuild()
    // called during build" — found live, 2026-08-26, tapping the Azkar
    // counter to completion. Deferring the insert to just after the
    // frame finishes is the standard fix and makes every caller safe
    // at once, not just this one call site.
    WidgetsBinding.instance.addPostFrameCallback((_) => overlay.insert(entry));
  }

  static Offset? _centerOf(BuildContext context) {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return null;
    return renderObject.localToGlobal(
      renderObject.size.center(Offset.zero),
    );
  }
}

class _ParticleBurstOverlay extends StatefulWidget {
  const _ParticleBurstOverlay({
    required this.center,
    required this.intensity,
    required this.color,
    required this.onComplete,
  });

  final Offset center;
  final double intensity;
  final Color color;
  final VoidCallback onComplete;

  @override
  State<_ParticleBurstOverlay> createState() => _ParticleBurstOverlayState();
}

class _ParticleBurstOverlayState extends State<_ParticleBurstOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<BurstParticle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = BurstParticle.generate(widget.intensity);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 550 + (widget.intensity * 250).round(),
      ),
    )..forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ParticleBurstPainter(
            center: widget.center,
            progress: _controller.value,
            particles: _particles,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
