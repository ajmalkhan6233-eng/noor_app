// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Collapses ProfileNameCard away with a real transition once a name
// is saved, instead of it just sitting there permanently or snapping
// away instantly. Same AnimatedSize + AnimatedSwitcher pairing as
// animated_calibration_banner.dart: AnimatedSwitcher (not a ternary
// child under one shared AnimatedOpacity) keeps the outgoing card
// mounted and fading while the incoming state fades in, and
// AnimatedSize handles the page reflowing around that as it plays out.

import 'package:flutter/material.dart';

import '../../../../core/presentation/motion/motion.dart';

class NameEntryTransition extends StatelessWidget {
  const NameEntryTransition({super.key, required this.show, required this.child});

  final bool show;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final duration = Motion.effective(context, Motion.duration);
    return AnimatedSize(
      duration: duration,
      curve: Motion.curve,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Motion.curve,
        switchOutCurve: Motion.curve,
        child: show
            ? KeyedSubtree(key: const ValueKey('name-entry-shown'), child: child)
            : const SizedBox(key: ValueKey('name-entry-hidden'), width: double.infinity),
      ),
    );
  }
}
