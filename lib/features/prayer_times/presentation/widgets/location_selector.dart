// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// GPS auto-fetches on load (see PrayerCubit.loadSettings) — a
// first-time user never has to do anything. This widget only ever
// shows raw lat/lng entry or the district picker when GPS hasn't
// resolved yet, or once the user explicitly asks to change location.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';
import '../../logic/prayer_cubit/prayer_cubit.dart';
import '../../logic/prayer_cubit/prayer_state.dart';
import 'district_selector.dart';
import 'manual_coordinates_entry.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  var _expanded = false;
  var _showManualEntry = false;

  void _useGps(BuildContext context) {
    context.read<PrayerCubit>().useGps();
    context.read<SettingsCubit>().setSelectedDistrict(null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        final showOptions =
            _expanded || (!state.hasCoordinates && !state.isResolvingLocation);
        return showOptions ? _optionsCard(context, state, l10n) : _statusRow(state);
      },
    );
  }

  Widget _statusRow(PrayerState state) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: AppColors.emerald, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              state.usingGps ? 'Location: current (GPS)' : 'Location set',
              style: AppTypography.caption,
            ),
          ),
          SemanticButton(
            label: 'Change location',
            hint: 'Double tap to change how your location is set',
            onTap: () => setState(() => _expanded = true),
            child: const Text('Change', style: TextStyle(color: AppColors.emerald)),
          ),
        ],
      ),
    );
  }

  Widget _optionsCard(BuildContext context, PrayerState state, AppLocalizations l10n) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SemanticButton(
            label: l10n.useGpsSemanticLabel,
            hint: l10n.useGpsHint,
            onTap: () => _useGps(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                state.isResolvingLocation ? l10n.locatingLabel : l10n.useMyLocationLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (state.locationError != null) ...[
            const SizedBox(height: 8),
            Text(state.locationError!, style: const TextStyle(color: AppColors.sage)),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.hairline, height: 1),
          const SizedBox(height: 12),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) => DistrictSelector(
              selectedDistrict: settingsState.settings.selectedDistrict,
              onSelected: (district) {
                context.read<PrayerCubit>().setManualLocation(
                  district.latitude,
                  district.longitude,
                );
                context.read<SettingsCubit>().setSelectedDistrict(district.name);
                setState(() => _expanded = false);
              },
            ),
          ),
          const SizedBox(height: 8),
          SemanticButton(
            label: _showManualEntry ? 'Hide manual entry' : 'Enter manually (advanced)',
            onTap: () => setState(() => _showManualEntry = !_showManualEntry),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                _showManualEntry ? 'Hide manual entry' : 'Enter manually (advanced)',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.sage, fontSize: 13),
              ),
            ),
          ),
          if (_showManualEntry)
            ManualCoordinatesEntry(
              onApply: (lat, lng) {
                context.read<PrayerCubit>().setManualLocation(lat, lng);
                context.read<SettingsCubit>().setSelectedDistrict(null);
                setState(() => _expanded = false);
              },
            ),
        ],
      ),
    );
  }
}
