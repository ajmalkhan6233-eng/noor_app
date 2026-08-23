// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Per-character digit-roll for numbers that change in front of the
// user (countdown seconds, streak day count) — an odometer-style
// slide+fade per character instead of the whole string snapping to
// new text. Per noor-kinetic-typography: a real, offline, performant
// "precision" feeling without particles on every tick.
//
// Uses AnimatedSwitcher per character (an implicit animation, not a
// manually-managed AnimationController), per noor-animation-performance.
// Each character position keeps its own stable slot across rebuilds
// (Row children are reconciled by index); only positions whose
// character actually changed re-key and transition — unchanged
// digits and separators (":", spaces) never animate.

import 'package:flutter/material.dart';

class KineticDigits extends StatelessWidget {
  const KineticDigits({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 220),
    this.semanticsLabel,
  });

  final String text;
  final TextStyle style;
  final Duration duration;

  /// Without this, the per-character Text widgets below would each
  /// surface their own implicit semantics node — a screen reader
  /// would spell the value out letter by letter instead of reading it
  /// as one string. Pass the full string here if nothing else already
  /// wraps this widget in its own Semantics(label: ...); leave it
  /// null (and this widget just excludes its own nodes) when a caller
  /// already provides an outer label — e.g. a liveRegion wrapper that
  /// also needs to say more than just this number.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final char in text.characters)
          AnimatedSwitcher(
            duration: duration,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => ClipRect(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.6),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
            ),
            child: Text(char, key: ValueKey(char), style: style),
          ),
      ],
    );
    final label = semanticsLabel;
    if (label == null) return ExcludeSemantics(child: row);
    return Semantics(label: label, child: ExcludeSemantics(child: row));
  }
}

extension _Characters on String {
  Iterable<String> get characters => split('');
}
