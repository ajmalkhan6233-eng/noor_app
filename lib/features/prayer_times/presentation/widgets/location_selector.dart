// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// GPS is one tap away but never required — manual latitude/longitude
// entry alone is fully sufficient to see prayer times.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SemanticButton(
                label: AppStrings.useGpsSemanticLabel,
                hint: 'Double tap to resolve your location via GPS',
                onTap: () => context.read<PrayerCubit>().useGps(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    state.isResolvingLocation
                        ? 'Locating…'
                        : 'Use my location',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.gold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _field(_latController, 'Latitude', true)),
                  const SizedBox(width: 8),
                  Expanded(child: _field(_lngController, 'Longitude', false)),
                ],
              ),
              const SizedBox(height: 8),
              SemanticButton(
                label: AppStrings.applyManualLocationSemanticLabel,
                onTap: () => _applyManual(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Apply coordinates',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.parchment),
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

  Widget _field(TextEditingController controller, String label, bool isLat) {
    return Semantics(
      textField: true,
      label: isLat
          ? AppStrings.manualLatitudeSemanticLabel
          : AppStrings.manualLongitudeSemanticLabel,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.parchment),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
