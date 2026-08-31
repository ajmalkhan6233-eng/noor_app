// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The small "FACING x° / QIBLA x°" readout tucked to the side of the
// compass dial (2026-08-30 mockup rebuild) — replaces the old
// QiblaInfoPanel corner badge, which no longer has a home now that the
// route card owns the top of the screen.

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(l10n.qiblaFacingReadoutLabel, style: TextStyle(color: colors.sage, fontSize: 9.5)),
            Text(headingText, style: TextStyle(color: colors.ink, fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(l10n.qiblaBearingReadoutLabel, style: TextStyle(color: colors.sage, fontSize: 9.5)),
            Text(bearingText, style: TextStyle(color: colors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
