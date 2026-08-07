// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Centred orb + its dhikr label. No longer draggable-to-reposition —
// the orb's own pull/tilt/spring-back gesture (TasbihOrb) needs the
// same pan gesture a free-drag reposition would, and the two can't
// coexist on one touch target without fighting over it. The tactile
// pull-and-snap is the more valuable interaction of the two.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'tasbih_orb.dart';

class DraggableCounterGroup extends StatelessWidget {
  const DraggableCounterGroup({
    super.key,
    required this.dhikrLabel,
    required this.count,
    required this.pulsing,
    required this.onTap,
  });

  final String dhikrLabel;
  final int count;
  final bool pulsing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: AppLocalizations.of(
                context,
              )!.currentlyCountingLabel(dhikrLabel),
              child: Text(
                dhikrLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.sage, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            TasbihOrb(count: count, pulsing: pulsing, onTap: onTap),
          ],
        ),
      ),
    );
  }
}
