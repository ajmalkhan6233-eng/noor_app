// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The small "FACING x° / QIBLA x°" readout below the compass dial
// (2026-08-30 mockup rebuild) — replaces the old QiblaInfoPanel corner
// badge. Originally drawn inside the dial itself, tucked to one side
// like the mockup shows; moved to a plain row underneath it after live
// testing found it could land under the Kaaba badge/needle, which
// rotates to the live bearing and can point anywhere.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';

class QiblaHeadingReadout extends StatelessWidget {
  const QiblaHeadingReadout({super.key, required this.headingDegrees, required this.bearingDegrees});

  final double? headingDegrees;
  final double bearingDegrees;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final headingText = headingDegrees == null ? '—' : '${headingDegrees!.round().toString().padLeft(3, '0')}°';
    final bearingText = '${bearingDegrees.round().toString().padLeft(3, '0')}°';

    return Semantics(
      label: 'Facing $headingText, qibla bearing $bearingText',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.qiblaFacingReadoutLabel, style: TextStyle(color: colors.sage, fontSize: 9.5)),
            const SizedBox(width: 6),
            Text(headingText, style: TextStyle(color: colors.ink, fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(width: 18),
            Text(l10n.qiblaBearingReadoutLabel, style: TextStyle(color: colors.sage, fontSize: 9.5)),
            const SizedBox(width: 6),
            Text(bearingText, style: TextStyle(color: colors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
