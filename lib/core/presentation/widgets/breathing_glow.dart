// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A soft gold light that slowly breathes behind a card. Only the glow
// layer animates; the child is built once and never rebuilt or scaled,
// so text stays crisp and the cost on budget phones stays small. With
// reduce-motion on, the glow holds still at its resting strength.

import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';
import '../motion/motion.dart';

class BreathingGlow extends StatefulWidget {
  const BreathingGlow({super.key, required this.child, this.radius = 20});

  final Widget child;

  /// Corner radius of the card being lit (matches the child).
  final double radius;

  @override
  State<BreathingGlow> createState() => _BreathingGlowState();
}

class _BreathingGlowState extends State<BreathingGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  );
  late final Animation<double> _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.colors.flatSurfaces) {
      _controller.stop(); // flat themes (Mushaf) stay glow-free
    } else if (Motion.reduced(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (colors.flatSurfaces) return widget.child;
    final isLight = colors.brightness == Brightness.light;
    final low = isLight ? 0.05 : 0.08;
    final high = isLight ? 0.12 : 0.22;
    final radius = BorderRadius.circular(widget.radius);

    return RepaintBoundary(
      child: Stack(
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: AnimatedBuilder(
                animation: _curve,
                builder: (context, _) => DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    boxShadow: [
                      BoxShadow(
                        color: colors.gold.withValues(
                          alpha: low + (high - low) * _curve.value,
                        ),
                        blurRadius: 24,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
