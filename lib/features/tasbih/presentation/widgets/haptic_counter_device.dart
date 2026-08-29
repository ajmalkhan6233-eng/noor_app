// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Replaces the drag-and-spring-back TasbihOrb, 2026-08-30, per direct
// request: fixed in place, tap only, styled like a small clicker
// device instead of an orb you have to chase. A milestone (33/66/100)
// still gets its own particle burst + shake, same as the orb did —
// only the idle/drag physics are gone, not the milestone feedback.

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

class _HapticCounterDeviceState extends State<HapticCounterDevice> with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 260),
    );
  }

  @override
  void didUpdateWidget(HapticCounterDevice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !oldWidget.pulsing) {
      ParticleBurst.play(context);
    }
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapController.forward().then((_) => _tapController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: semanticCountLabel(l10n.tasbihCounterSemanticLabel, widget.count),
      hint: l10n.tasbihIncrementHint,
      onTap: _handleTap,
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
            GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              child: AnimatedScale(
                scale: _pressed ? 0.92 : 1.0,
                duration: const Duration(milliseconds: 80),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.gold,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.gold.withValues(alpha: 0.5),
                        blurRadius: _pressed ? 4 : 16,
                        spreadRadius: _pressed ? 0 : 2,
                      ),
                    ],
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
