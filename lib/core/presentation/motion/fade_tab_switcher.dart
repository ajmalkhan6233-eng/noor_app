// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Cross-fades between bottom-nav tabs with a subtle upward slide,
// instead of IndexedStack's instant swap. All tabs stay mounted (each
// screen owns and persists its own state), so switching back and
// forth never resets scroll position, search text, or counters.

import 'package:flutter/material.dart';

import 'motion.dart';

class FadeTabSwitcher extends StatelessWidget {
  const FadeTabSwitcher({
    super.key,
    required this.index,
    required this.children,
  });

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < children.length; i++)
          _TabLayer(active: i == index, child: children[i]),
      ],
    );
  }
}

class _TabLayer extends StatelessWidget {
  const _TabLayer({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final duration = Motion.effective(context, Motion.duration);
    return IgnorePointer(
      ignoring: !active,
      child: ExcludeSemantics(
        excluding: !active,
        child: AnimatedOpacity(
          opacity: active ? 1 : 0,
          duration: duration,
          curve: Motion.curve,
          child: AnimatedSlide(
            offset: active ? Offset.zero : const Offset(0, 0.02),
            duration: duration,
            curve: Motion.curve,
            child: child,
          ),
        ),
      ),
    );
  }
}
