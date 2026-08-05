// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A third, fully offline location option alongside GPS and manual
// coordinates: pick one of Sri Lanka's 25 districts. Pure/reusable —
// the caller supplies the currently selected name and what happens on
// selection, so both Prayer Times and the Qibla GPS-fallback share
// this one dropdown rather than each having their own.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/sri_lanka_district.dart';

class DistrictSelector extends StatelessWidget {
  const DistrictSelector({
    super.key,
    required this.selectedDistrict,
    required this.onSelected,
  });

  final String? selectedDistrict;
  final ValueChanged<SriLankaDistrict> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Semantics(
        label: l10n.districtSelectorSemanticLabel,
        value: selectedDistrict ?? l10n.noneSelectedLabel,
        child: DropdownButtonFormField<String>(
          initialValue: selectedDistrict,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.districtFieldLabel),
          dropdownColor: AppColors.card,
          hint: Text(l10n.chooseDistrictHint),
          items: [
            for (final district in sriLankaDistricts)
              DropdownMenuItem(
                value: district.name,
                child: Text(district.name),
              ),
          ],
          onChanged: (name) {
            final district = findSriLankaDistrict(name);
            if (district != null) onSelected(district);
          },
        ),
      ),
    );
  }
}
