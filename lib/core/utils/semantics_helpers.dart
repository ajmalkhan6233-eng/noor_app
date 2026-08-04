// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Small helpers to keep Semantics() usage consistent across the app.
// Prefer `SemanticButton` over a raw Semantics()+GestureDetector pair
// so every interactive element gets the same button/focus/hint shape —
// and, since it's the one chokepoint every tappable card and row goes
// through, the same calm 0.98 press-scale for free.

import 'package:flutter/material.dart';

import '../presentation/motion/motion.dart';

/// Wraps [child] as an accessible, tappable element with a mandatory
/// [label], satisfying `.clinerules` §4 (every interactive widget must
/// carry an explicit Semantics tag for VoiceOver/TalkBack).
class SemanticButton extends StatefulWidget {
  const SemanticButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.child,
    this.hint,
    this.enabled = true,
  });

  /// Screen-reader label, e.g. "Tasbih counter".
  final String label;

  /// Optional screen-reader hint, e.g. "Double tap to increment".
  final String? hint;

  final VoidCallback onTap;
  final Widget child;
  final bool enabled;

  @override
  State<SemanticButton> createState() => _SemanticButtonState();
}

class _SemanticButtonState extends State<SemanticButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.label,
      hint: widget.hint,
      onTap: widget.enabled ? widget.onTap : null,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
        onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
        onTapCancel: widget.enabled ? () => _setPressed(false) : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: Motion.effective(context, Motion.short),
          curve: Motion.curve,
          child: ExcludeSemantics(child: widget.child),
        ),
      ),
    );
  }
}

/// Builds a screen-reader-friendly live value announcement, e.g. for a
/// counter whose value changes frequently ("Count: 34").
String semanticCountLabel(String subject, int value) => '$subject: $value';
