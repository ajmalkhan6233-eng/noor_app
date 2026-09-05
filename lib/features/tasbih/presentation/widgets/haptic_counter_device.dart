// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// "Glass Bead" — a glossy 3D sphere in the same material language as
// the bottom-nav orb badges (noor_icon_style.dart's paintNavOrbBadge),
// scaled up into a touch target. Pressing it sinks the highlight and
// tightens the shadow rather than just recoloring.
//
// 2026-09-05: replaced an inner GestureDetector (onTapDown/Up/Cancel
// only, no onTap) that was silently winning the gesture arena over
// this widget's own SemanticButton — the visual press worked but the
// actual tap (onTap -> TasbihCubit.increment()) never fired. Fixed by
// driving the press-visual off a Listener instead, which doesn't
// participate in tap gesture resolution at all, so there's only ever
// one recognizer competing for the tap.

import 'package:flutter/material.dart';

import '../../../../core/effects/particle_burst.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';

class HapticCounterDevice extends StatefulWidget {
  const HapticCounterDevice({
    super.key,
    required this.count,
    required this.onTap,
    this.pulsing = false,
  });

  final int count;
  final VoidCallback onTap;
  final bool pulsing;

  @override
  State<HapticCounterDevice> createState() => _HapticCounterDeviceState();
}

class _HapticCounterDeviceState extends State<HapticCounterDevice> {
  bool _pressed = false;

  @override
  void didUpdateWidget(HapticCounterDevice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !oldWidget.pulsing) {
      ParticleBurst.play(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: semanticCountLabel(l10n.tasbihCounterSemanticLabel, widget.count),
      hint: l10n.tasbihIncrementHint,
      onTap: widget.onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: widget.pulsing ? context.colors.gold : context.colors.hairline,
            width: widget.pulsing ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text('${widget.count}', style: AppTypography.counter(context.colors.ink)),
            const SizedBox(height: 20),
            Listener(
              onPointerDown: (_) => setState(() => _pressed = true),
              onPointerUp: (_) => setState(() => _pressed = false),
              onPointerCancel: (_) => setState(() => _pressed = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 90),
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: _pressed ? const Alignment(0, 0) : const Alignment(-0.35, -0.4),
                    radius: 0.9,
                    colors: _pressed
                        ? const [Color(0xFFB87A00), Color(0xFFFFDD8C)]
                        : const [Color(0xFFFFEFC2), Color(0xFFFFB703), Color(0xFFB87A00)],
                  ),
                  border: Border.all(color: const Color(0xFF8A5A00), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _pressed ? 0.5 : 0.3),
                      blurRadius: _pressed ? 4 : 14,
                      spreadRadius: _pressed ? -2 : 1,
                    ),
                  ],
                ),
                child: _pressed
                    ? null
                    : Align(
                        alignment: const Alignment(-0.4, -0.5),
                        child: Container(
                          width: 26,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
