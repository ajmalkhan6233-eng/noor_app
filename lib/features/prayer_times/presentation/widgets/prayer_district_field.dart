// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Wires the shared DistrictSelector to Prayer Times: reads the
// persisted selection from Settings, sets PrayerCubit's coordinates
// and persists the choice via SettingsCubit when one is picked.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';
import '../../logic/prayer_cubit/prayer_cubit.dart';
import 'district_selector.dart';

class PrayerDistrictField extends StatelessWidget {
  const PrayerDistrictField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return DistrictSelector(
          selectedDistrict: state.settings.selectedDistrict,
          onSelected: (district) {
            context.read<PrayerCubit>().setManualLocation(
              district.latitude,
              district.longitude,
            );
            context.read<SettingsCubit>().setSelectedDistrict(district.name);
          },
        );
      },
    );
  }
}
