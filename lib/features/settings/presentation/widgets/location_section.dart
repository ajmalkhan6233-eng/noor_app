// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The one place location is ever changed after first launch — GPS or
// a Sri Lankan district. Settings doesn't share Prayer Times/Qibla's
// PrayerCubit (it's a separate pushed route, outside that provider
// scope), so this talks to LocationService and SettingsCubit directly;
// MoreScreen's Settings row re-syncs PrayerCubit when this screen
// closes.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/presentation/widgets/district_selector.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';
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
    setState(() => _resolving = false);
    if (coordinates == null) {
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context)!.locationResolveFailedMessage,
        );
      }
      return;
    }
    await context.read<SettingsCubit>().setSelectedDistrict(null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final district = state.settings.selectedDistrict;
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
            ],
            if (district == null) ...[
              const SizedBox(height: 8),
              Text(l10n.usingGpsAutoResolveMessage, style: AppTypography.caption(context.colors.sage)),
            ],
            const SizedBox(height: 12),
            Divider(color: context.colors.hairline, height: 1),
            const SizedBox(height: 12),
            DistrictSelector(
              selectedDistrict: district,
              onSelected: (selected) {
                context.read<SettingsCubit>().setSelectedDistrict(selected.name);
              },
            ),
          ],
        );
      },
    );
  }
}
