// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one place location is changed after first launch. GPS only, no
// manual place picker. When location permission is missing this shows a
// small "Allow location" button (the only place the app ever offers it
// again); when it is on, a plain "Use my location" refresh. It checks
// again whenever the app returns to the foreground, so turning location
// on in the phone's settings is noticed. Settings is a separate pushed
// route, so this talks to LocationService directly; MoreScreen re-syncs
// PrayerCubit when Settings closes.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class LocationSection extends StatefulWidget {
  const LocationSection({super.key, this.locationService = const LocationService()});

  final LocationService locationService;

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> with WidgetsBindingObserver {
  bool _resolving = false;
  bool? _allowed;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshPermission();
  }

  Future<void> _refreshPermission() async {
    final allowed = await widget.locationService.hasPermission();
    if (mounted) setState(() => _allowed = allowed);
  }

  Future<void> _useGps() async {
    setState(() {
      _resolving = true;
      _error = null;
    });
    final coordinates = await widget.locationService.getCurrentCoordinates();
    if (coordinates == null && await widget.locationService.isPermanentlyDenied()) {
      // Android will not prompt again: send the user to the app settings.
      await widget.locationService.openAppSettings();
    }
    final allowed = await widget.locationService.hasPermission();
    if (!mounted) return;
    setState(() {
      _resolving = false;
      _allowed = allowed;
      _error = coordinates == null && allowed
          ? AppLocalizations.of(context)!.locationResolveFailedMessage
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final allowed = _allowed ?? true; // no flash of a button before the check
    final caption = _error ?? (allowed ? l10n.settingsLocationAllowedCaption : l10n.settingsLocationOffCaption);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SemanticButton(
          label: allowed ? l10n.useGpsSemanticLabel : l10n.settingsAllowLocation,
          hint: allowed ? l10n.useGpsHint : l10n.settingsAllowLocationHint,
          onTap: _useGps,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              _resolving
                  ? l10n.locatingLabel
                  : (allowed ? l10n.useMyLocationLabel : l10n.settingsAllowLocation),
              textAlign: TextAlign.center,
              style: AppTypography.bodyStrong(colors.gold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(caption, style: AppTypography.caption(colors.sage)),
      ],
    );
  }
}
