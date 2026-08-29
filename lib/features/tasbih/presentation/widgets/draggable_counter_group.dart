// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Centred counter device + its dhikr label. Was previously a
// draggable orb (TasbihOrb) with a pull/tilt/spring-back gesture;
// replaced 2026-08-30 per direct request with HapticCounterDevice, a
// fixed-in-place tap-only clicker — "not working for daily use."

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'haptic_counter_device.dart';

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
                style: TextStyle(color: context.colors.sage, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            HapticCounterDevice(count: count, pulsing: pulsing, onTap: onTap),
          ],
        ),
      ),
    );
  }
}
