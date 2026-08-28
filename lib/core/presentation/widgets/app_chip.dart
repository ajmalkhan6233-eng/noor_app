// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A hand-rolled chip instead of Material's ChoiceChip — Chip pulls in
// M3 elevation tinting and defaults to a solid fill we don't want.
// Gold is punctuation: selected chips get a hairline gold border and
// gold text, never a solid gold fill. Presses use the same calm
// 0.98 scale-down as SemanticButton, so every tappable element in the
// app responds to touch the same way.

import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';
import '../motion/motion.dart';

class AppChip extends StatefulWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.semanticLabel,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      selected: widget.selected,
      button: true,
      child: InkWell(
        onTap: () {
          _setPressed(false);
          widget.onTap();
        },
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: Motion.effective(context, Motion.short),
          curve: Motion.curve,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.selected ? context.colors.card : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.selected ? context.colors.gold : context.colors.hairline,
              ),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.selected ? context.colors.gold : context.colors.sage,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
