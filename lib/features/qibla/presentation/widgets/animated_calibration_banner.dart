// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of qibla_screen.dart to stay under the 150-line-per-file
// rule. AnimatedSize + AnimatedSwitcher instead of a raw `if`: the old
// hard mount/unmount reported repeatedly as "the compass is blinking"
// even after the needle's own alpha was smoothed — it wasn't the
// needle, it was this banner popping in and out instantly, which also
// snapped the compass area below to a different height on every
// toggle. AnimatedSwitcher (not a ternary child under a shared
// AnimatedOpacity) matters here: a ternary swaps the child widget on
// the very same frame the opacity starts animating, so the banner
// would still vanish instantly instead of fading — AnimatedSwitcher
// keeps the outgoing child mounted and fading while the incoming one
// fades in. AnimatedSize outside handles the height collapse as that
// swap plays out (2026-08-27).

import 'package:flutter/material.dart';

import 'calibration_prompt.dart';

class AnimatedCalibrationBanner extends StatelessWidget {
  const AnimatedCalibrationBanner({super.key, required this.show});

  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: show
            ? const Padding(
                key: ValueKey('calibration-shown'),
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: CalibrationPrompt(),
              )
            : const SizedBox(key: ValueKey('calibration-hidden'), width: double.infinity),
      ),
    );
  }
}
