// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A third, fully offline location option alongside GPS and manual
// coordinates: pick one of Sri Lanka's 25 districts. Selecting one
// sets PrayerCubit's coordinates and persists the district name via
// SettingsCubit so it shows as selected again after a restart.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';
import '../../data/sri_lanka_district.dart';
import '../../logic/prayer_cubit/prayer_cubit.dart';

/// Dropdown of Sri Lankan districts — a no-permission, no-GPS
/// alternative to entering coordinates by hand.
class DistrictSelector extends StatelessWidget {
  const DistrictSelector({super.key});

  void _select(BuildContext context, SriLankaDistrict district) {
    context.read<PrayerCubit>().setManualLocation(
      district.latitude,
      district.longitude,
    );
    context.read<SettingsCubit>().setSelectedDistrict(district.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final selected = state.settings.selectedDistrict;
        return AppCard(
          child: Semantics(
            label: AppStrings.districtSelectorSemanticLabel,
            value: selected ?? 'None selected',
            child: DropdownButtonFormField<String>(
              initialValue: selected,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Sri Lankan district (optional)',
              ),
              dropdownColor: AppColors.card,
              hint: const Text('Choose a district'),
              items: [
                for (final district in sriLankaDistricts)
                  DropdownMenuItem(
                    value: district.name,
                    child: Text(district.name),
                  ),
              ],
              onChanged: (name) {
                if (name == null) return;
                final match = sriLankaDistricts.where((d) => d.name == name);
                if (match.isEmpty) return;
                _select(context, match.first);
              },
            ),
          ),
        );
      },
    );
  }
}
