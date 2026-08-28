// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_color_tokens.dart';

class ZakatNumberField extends StatefulWidget {
  const ZakatNumberField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
  });

  final String label;
  final ValueChanged<double> onChanged;

  /// Pre-fills the field — used for the gold/silver price fields,
  /// which remember the last-entered value (2026-08-25 audit: "Zakat
  /// calculator asks for gold/silver prices every time"). `null` for
  /// every other field on this screen, which genuinely changes each
  /// visit and shouldn't be pre-filled.
  final double? initialValue;

  @override
  State<ZakatNumberField> createState() => _ZakatNumberFieldState();
}

class _ZakatNumberFieldState extends State<ZakatNumberField> {
  // A stable controller, not one rebuilt inline in build() — the
  // parent's initialValue arrives asynchronously (loaded from
  // storage) after first render, and once it does, every keystroke
  // triggers the parent's own rebuild. Recreating the controller each
  // time would reset the cursor to the start after every character
  // typed — same bug class as progress_screen.dart's name field.
  late final _controller = TextEditingController(
    text: widget.initialValue == null ? '' : widget.initialValue!.toStringAsFixed(2),
  );
  var _seeded = false;

  @override
  void didUpdateWidget(ZakatNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Seed exactly once, the first time a remembered value arrives —
    // after that, the field itself is the source of truth.
    if (!_seeded && widget.initialValue != null) {
      _seeded = true;
      _controller.text = widget.initialValue!.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        textField: true,
        label: widget.label,
        child: TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: context.colors.ink),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: AppTypography.caption(context.colors.sage),
          ),
          onChanged: (v) => widget.onChanged(double.tryParse(v) ?? 0),
        ),
      ),
    );
  }
}
