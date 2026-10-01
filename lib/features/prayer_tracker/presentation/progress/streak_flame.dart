// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/motion/motion.dart';

/// A small flame that breathes gently while a streak is alive, and is
/// a quiet outline when there is no streak.
class StreakFlame extends StatefulWidget {
  const StreakFlame({super.key, required this.streak, this.size = 26});

  final int streak;
  final double size;

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(StreakFlame old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final shouldAnimate = widget.streak > 0 && !Motion.reduced(context);
    if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!shouldAnimate && _controller.isAnimating) {
      _controller.stop();
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
    if (widget.streak <= 0) {
      return Icon(Icons.local_fire_department_outlined, size: widget.size, color: colors.hairline);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Transform.scale(
        scale: 1 + 0.12 * Curves.easeInOut.transform(_controller.value),
        child: Icon(Icons.local_fire_department, size: widget.size, color: colors.gold),
      ),
    );
  }
}
