// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of home_quick_toggles.dart to stay under the 150-line
// limit — the shared glass-pill shell and glow-icon both quick-toggle
// chips use. Deliberately static styling only (see
// home_quick_toggles.dart's own header for why, given tonight's Qibla
// needle lesson about per-frame draw complexity).

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/utils/semantics_helpers.dart';
import '../../../../core/constants/app_color_tokens.dart';

/// A simple on/off glass-pill toggle chip — icon + label, no dropdown
/// (see PreAdhanReminderChip for the one with a popup menu).
class QuickToggleChip extends StatelessWidget {
  const QuickToggleChip({
    super.key,
    required this.icon,
    required this.label,
    required this.on,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: label,
      hint: on ? 'On. Double tap to turn off' : 'Off. Double tap to turn on',
      onTap: onTap,
      child: GlassPill(
        on: on,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlowIcon(icon, on: on),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: on ? context.colors.gold : context.colors.sage, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// The shared glass-pill shell both quick-toggle chips sit inside —
/// a `BackdropFilter` blur (computed once per build, not per frame)
/// over a translucent card fill, matching GlassCard's own technique
/// elsewhere in the app rather than inventing a new one.
class GlassPill extends StatelessWidget {
  const GlassPill({super.key, required this.on, required this.child});

  final bool on;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: context.colors.card.withValues(alpha: on ? 0.65 : 0.3),
            borderRadius: borderRadius,
            border: Border.all(color: on ? context.colors.gold : context.colors.hairline),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A quick-toggle icon with a soft glow behind it when on — a single
/// static `BoxShadow`, painted once, not an animated/per-frame effect.
class GlowIcon extends StatelessWidget {
  const GlowIcon(this.icon, {super.key, required this.on});

  final IconData icon;
  final bool on;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: on
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: context.colors.gold.withValues(alpha: 0.45), blurRadius: 8, spreadRadius: 1),
              ],
            )
          : null,
      child: Icon(icon, size: 16, color: on ? context.colors.gold : context.colors.sage),
    );
  }
}
