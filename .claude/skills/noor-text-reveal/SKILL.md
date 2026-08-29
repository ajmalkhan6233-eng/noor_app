---
name: noor-text-reveal
description: Use when text should build up character-by-character and later fade/dissolve away, rather than simply appearing and disappearing instantly (e.g. "Daily prayer" style messages). Companion to noor-kinetic-typography, focused specifically on this letter-reveal pattern.
---

# noor Text Reveal

## The effect
Text builds up progressively (letter by letter, or word by word), holds
briefly once complete, then fades away as a whole — a calm, readable
reveal, not a fast typewriter-clatter effect. Fits noor's unhurried,
premium motion language (per noor-kinetic-typography).

## Ready implementation
```dart
import 'package:flutter/material.dart';

class RevealText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration revealDuration;
  final Duration holdDuration;
  final Duration fadeDuration;
  const RevealText({
    super.key,
    required this.text,
    this.style,
    this.revealDuration = const Duration(milliseconds: 900),
    this.holdDuration = const Duration(milliseconds: 1400),
    this.fadeDuration = const Duration(milliseconds: 600),
  });

  @override
  State<RevealText> createState() => _RevealTextState();
}

class _RevealTextState extends State<RevealText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final total = widget.revealDuration + widget.holdDuration + widget.fadeDuration;
    _controller = AnimationController(vsync: this, duration: total)..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final elapsed = _controller.value * _controller.duration!.inMilliseconds;
        final revealMs = widget.revealDuration.inMilliseconds;
        final holdEndMs = revealMs + widget.holdDuration.inMilliseconds;
        final totalMs = _controller.duration!.inMilliseconds;

        // Reveal phase: how many characters are visible.
        final revealProgress = (elapsed / revealMs).clamp(0.0, 1.0);
        final visibleChars = (widget.text.length * revealProgress).round();
        final visibleText = widget.text.substring(0, visibleChars);

        // Fade phase: opacity after the hold period ends.
        double opacity = 1.0;
        if (elapsed > holdEndMs) {
          final fadeProgress = ((elapsed - holdEndMs) / (totalMs - holdEndMs)).clamp(0.0, 1.0);
          opacity = 1.0 - fadeProgress;
        }

        return Opacity(opacity: opacity, child: Text(visibleText, style: widget.style));
      },
    );
  }
}
// Usage: RevealText(text: "Daily Prayer", style: ...)
// Loop by wrapping with a periodic rebuild/restart if a repeating
// effect is wanted, rather than baking looping into this widget itself.
```

Apply noor-animation-performance: don't run this on more than one or
two elements simultaneously on a single screen, to avoid unnecessary
constant rebuilds.
