// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The small "FACING x° / QIBLA x°" readout below the compass dial
// (2026-08-30 mockup rebuild) — replaces the old QiblaInfoPanel corner
// badge. Originally drawn inside the dial itself, tucked to one side
// like the mockup shows; moved to a plain row underneath it after live
// testing found it could land under the Kaaba badge/needle, which
// rotates to the live bearing and can point anywhere.
//
// 2026-09-03: restyled as a glass HUD panel (GlassCard — the existing
// isolated, opt-in BackdropFilter widget, not AppCard; see GlassCard's
// own header for why it's kept separate) with cyan telemetry-style
// figures, matching the polish pass elsewhere on this screen. This is
// a plain BackdropFilter blur on a static container — unrelated to the
// needle painter's own no-gradient/no-blur constraint, which is
// specifically about the needle's rotating CustomPainter layer on this
// device, not glass panels generally (already used safely elsewhere).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/widgets/glass_card.dart';
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
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.qiblaFacingReadoutLabel,
                style: TextStyle(color: colors.accentSecondary.withValues(alpha: 0.75), fontSize: 9.5, letterSpacing: 1.2),
              ),
              const SizedBox(width: 6),
              Text(
                headingText,
                style: TextStyle(color: colors.accentSecondary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5),
              ),
              const SizedBox(width: 18),
              Text(
                l10n.qiblaBearingReadoutLabel,
                style: TextStyle(color: colors.accentSecondary.withValues(alpha: 0.75), fontSize: 9.5, letterSpacing: 1.2),
              ),
              const SizedBox(width: 6),
              Text(
                bearingText,
                style: TextStyle(color: colors.gold, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
