// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one place location is ever changed after first launch — GPS
// only (2026-09-13: the manual district picker was removed here and
// from onboarding; PrayerCubit falls back to Colombo on its own if GPS
// genuinely fails, see coordinate_bounds.dart). Settings doesn't share
// Prayer Times/Qibla's PrayerCubit (it's a separate pushed route,
// outside that provider scope), so this talks to LocationService
// directly; MoreScreen's Settings row re-syncs PrayerCubit when this
// screen closes.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_color_tokens.dart';

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  final _locationService = const LocationService();
  bool _resolving = false;
  String? _error;

  Future<void> _useGps() async {
    setState(() {
      _resolving = true;
      _error = null;
    });
    final coordinates = await _locationService.getCurrentCoordinates();
    if (!mounted) return;
    setState(() {
      _resolving = false;
      _error = coordinates == null
          ? AppLocalizations.of(context)!.locationResolveFailedMessage
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SemanticButton(
          label: l10n.useGpsSemanticLabel,
          hint: l10n.useGpsHint,
          onTap: _useGps,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              _resolving ? l10n.locatingLabel : l10n.useMyLocationLabel,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.gold, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: AppTypography.caption(context.colors.sage)),
        ] else ...[
          const SizedBox(height: 8),
          Text(l10n.usingGpsAutoResolveMessage, style: AppTypography.caption(context.colors.sage)),
        ],
      ],
    );
  }
}
