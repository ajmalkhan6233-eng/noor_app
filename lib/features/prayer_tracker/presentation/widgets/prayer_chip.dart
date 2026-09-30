// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/corner_radius.dart';

class PrayerChip extends StatelessWidget {
  const PrayerChip({super.key, 
    required this.label,
    required this.done,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool done;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = !enabled
        ? context.colors.hairline
        : done
        ? context.colors.gold
        : context.colors.sage;
    return SemanticButton(
      label: label,
      hint: !enabled
          ? 'Not yet due today'
          : done
          ? l10n.unmarkPrayerHint(label)
          : l10n.markPrayerDoneHint(label),
      enabled: enabled,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: done ? context.colors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(context.radiusFor(20)),
          border: Border.all(color: enabled ? (done ? context.colors.gold : context.colors.hairline) : context.colors.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
