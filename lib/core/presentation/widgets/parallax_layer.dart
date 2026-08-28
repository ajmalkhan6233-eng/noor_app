// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A light, app-wide "supporting detail" parallax: wraps a single
// decorative element (a hero/header card, usually) and shifts it by a
// small fraction of a ScrollController's offset, so it visually lags
// behind the rest of the scroll for a subtle sense of depth. Never the
// focal point — kept small (default factor 0.15) on purpose.
//
// Respects the system's reduced-motion setting: the shift collapses
// to zero rather than fighting an accessibility preference.

import 'package:flutter/material.dart';

class ParallaxLayer extends StatefulWidget {
  const ParallaxLayer({
    super.key,
    required this.controller,
    required this.child,
    this.factor = 0.15,
  });

  final ScrollController controller;
  final Widget child;
  final double factor;

  @override
  State<ParallaxLayer> createState() => _ParallaxLayerState();
}

/// Applies a small depth offset to content that moves inside a scroll view.
class ParallaxItem extends StatelessWidget {
  const ParallaxItem({
    super.key,
    required this.controller,
    required this.child,
    this.depth = 0.06,
  });

  final ScrollController controller;
  final Widget child;
  final double depth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final reduced = MediaQuery.of(context).disableAnimations;
        final offset = controller.hasClients && !reduced
            ? controller.offset * depth
            : 0.0;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: child,
        );
      },
    );
  }
}

class _ParallaxLayerState extends State<ParallaxLayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final offset = widget.controller.hasClients ? widget.controller.offset : 0.0;
    // Positive shift opposes the ListView's own upward scroll motion,
    // so net on-screen movement is offset * (1 - factor) — genuinely
    // slower than the rest of the content, not faster.
    final shift = reduceMotion ? 0.0 : offset * widget.factor;
    return Transform.translate(offset: Offset(0, shift), child: widget.child);
  }
}
