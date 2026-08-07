// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// UI-only country picker — explicitly not wired to any real data.
// Sri Lanka is the only country with working district/holiday data
// (see LocationSelector, sri_lanka_holiday.dart) and stays selected
// and fully functional; the rest render as visibly disabled rows with
// a "Coming soon" tag so nobody mistakes them for working options.
// Selection is local widget state only — nothing here is persisted.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class CountrySection extends StatefulWidget {
  const CountrySection({super.key});

  @override
  State<CountrySection> createState() => _CountrySectionState();
}

class _CountrySectionState extends State<CountrySection> {
  static const _sriLanka = 'sriLanka';
  String _selected = _sriLanka;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countries = <String, String>{
      _sriLanka: l10n.countrySriLanka,
      'india': l10n.countryIndia,
      'malaysia': l10n.countryMalaysia,
      'unitedKingdom': l10n.countryUnitedKingdom,
      'unitedStates': l10n.countryUnitedStates,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in countries.entries) ...[
          _row(context, key: entry.key, name: entry.value),
          if (entry.key != countries.keys.last) const Divider(color: AppColors.hairline, height: 1),
        ],
      ],
    );
  }

  Widget _row(BuildContext context, {required String key, required String name}) {
    final l10n = AppLocalizations.of(context)!;
    final isSriLanka = key == _sriLanka;
    final selected = key == _selected;

    return SemanticButton(
      label: name,
      hint: isSriLanka ? null : l10n.countryComingSoonHint,
      enabled: isSriLanka,
      onTap: () => setState(() => _selected = key),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 18,
              color: isSriLanka ? AppColors.gold : AppColors.sage,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(color: isSriLanka ? AppColors.ink : AppColors.sage),
              ),
            ),
            if (!isSriLanka)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.hairline),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.comingSoonLabel,
                  style: const TextStyle(color: AppColors.sage, fontSize: 11),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
