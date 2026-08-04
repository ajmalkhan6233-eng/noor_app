// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// GPS is one tap away but never required — manual latitude/longitude
// entry alone is fully sufficient to see prayer times.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../logic/prayer_cubit/prayer_cubit.dart';
import '../../logic/prayer_cubit/prayer_state.dart';

/// Location entry: a "use my location" button plus manual lat/lng
/// fields, either of which is enough on its own — a single tidy card.
class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _applyManual(BuildContext context) {
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);
    if (lat == null || lng == null) return;
    context.read<PrayerCubit>().setManualLocation(lat, lng);
    context.read<SettingsCubit>().setSelectedDistrict(null);
  }

  void _useGps(BuildContext context) {
    context.read<PrayerCubit>().useGps();
    context.read<SettingsCubit>().setSelectedDistrict(null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
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
                    state.isResolvingLocation
                        ? l10n.locatingLabel
                        : l10n.useMyLocationLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.emerald),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _field(context, _latController, l10n.latitudeLabel, true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _field(
                      context,
                      _lngController,
                      l10n.longitudeLabel,
                      false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SemanticButton(
                label: l10n.applyManualLocationSemanticLabel,
                onTap: () => _applyManual(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    l10n.applyCoordinatesLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.ink),
                  ),
                ),
              ),
              if (state.locationError != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.locationError!,
                  style: const TextStyle(color: AppColors.sage),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _field(
    BuildContext context,
    TextEditingController controller,
    String label,
    bool isLat,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      textField: true,
      label: isLat
          ? l10n.manualLatitudeSemanticLabel
          : l10n.manualLongitudeSemanticLabel,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.ink),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
