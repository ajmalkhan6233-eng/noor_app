// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The dhikr label and the counter button move together as one
// draggable unit — the label always follows the counter, never left
// behind at a fixed spot.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/draggable_floating.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'haptic_counter_button.dart';

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
    return DraggableFloating(
      size: const Size(240, 280),
      widgetKey: 'tasbih_counter',
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
            HapticCounterButton(count: count, pulsing: pulsing, onTap: onTap),
          ],
        ),
      ),
    );
  }
}
