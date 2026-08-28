// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A single pulsing placeholder rectangle — the building block for any
// screen's "waiting on data" state. Frozen (no pulse) under reduced
// motion, same convention as CosmicBackground's particles: it's a
// loading indicator, not decoration, so it just holds still instead
// of disappearing.

import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../../../core/constants/app_color_tokens.dart';

class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = reduced ? 0.5 : 0.35 + _controller.value * 0.3;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: context.colors.hairline.withValues(alpha: opacity),
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}
