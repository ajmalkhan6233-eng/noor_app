// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Small helpers to keep Semantics() usage consistent across the app.
// Prefer `SemanticButton` over a raw Semantics()+GestureDetector pair
// so every interactive element gets the same button/focus/hint shape.

import 'package:flutter/material.dart';

/// Wraps [child] as an accessible, tappable element with a mandatory
/// [label], satisfying `.clinerules` §4 (every interactive widget must
/// carry an explicit Semantics tag for VoiceOver/TalkBack).
class SemanticButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: hint,
      onTap: enabled ? onTap : null,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: ExcludeSemantics(child: child),
      ),
    );
  }
}

/// Builds a screen-reader-friendly live value announcement, e.g. for a
/// counter whose value changes frequently ("Count: 34").
String semanticCountLabel(String subject, int value) => '$subject: $value';
