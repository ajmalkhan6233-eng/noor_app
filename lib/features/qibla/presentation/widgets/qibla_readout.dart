// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/qibla_compass_state.dart';

/// Bearing, distance, live heading and the plain-language notices
/// (no compass, approximate location, calibrate, aligned).
class QiblaReadout extends StatelessWidget {
  const QiblaReadout({super.key, required this.state, required this.onAllowLocation});

  final QiblaCompassState state;
  final VoidCallback onAllowLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final bearing = state.bearing!.round();
    return Column(
      children: [
        Semantics(
          label: '${l10n.qiblaBearingReadoutLabel} ${l10n.qiblaDegreesFromNorth(bearing)}',
          excludeSemantics: true,
          child: Column(
            children: [
              Text('$bearing°', style: AppTypography.heroDisplay(colors.gold)),
              Text(l10n.qiblaDegreesFromNorth(bearing), style: AppTypography.caption(colors.sage)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.qiblaDistanceToKaaba(state.distanceKm!.round()),
          style: AppTypography.caption(colors.sage),
        ),
        if (state.hasHeading) ...[
          const SizedBox(height: 4),
          Text(
            '${l10n.qiblaFacingReadoutLabel} ${state.heading!.round()}°',
            style: AppTypography.caption(colors.sage),
          ),
        ],
        if (state.aligned) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.qiblaAlignedMessage,
              textAlign: TextAlign.center,
              style: AppTypography.bodyStrong(colors.accentSecondary),
            ),
          ),
        ],
        if (state.sensorUnavailable) _notice(context, l10n.qiblaStaticArrowMessage),
        if (state.needsCalibration) _notice(context, l10n.qiblaFigure8Hint),
        if (state.approximateLocation) ...[
          _notice(context, l10n.qiblaApproxLocationMessage),
          TextButton(
            onPressed: onAllowLocation,
            child: Text(l10n.qiblaAllowLocation, style: AppTypography.body(colors.gold)),
          ),
        ],
        if (state.hasHeading && !state.needsCalibration)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              l10n.qiblaFigure8Hint,
              textAlign: TextAlign.center,
              style: AppTypography.caption(colors.sage),
            ),
          ),
      ],
    );
  }

  Widget _notice(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: context.colors.ink, height: 1.4),
      ),
    );
  }
}
