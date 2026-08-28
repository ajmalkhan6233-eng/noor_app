// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sri Lanka is the only country with working district/holiday data
// (see LocationSelector, sri_lanka_holiday.dart). Used to list India/
// Malaysia/UK/US as visibly-disabled "Coming soon" rows alongside it;
// removed (2026-08-24 live-device review) — with nothing else
// actually selectable, those rows were just non-functional clutter,
// not useful information. This section now simply states the
// working country rather than presenting a picker with one real
// choice.

import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_color_tokens.dart';

class CountrySection extends StatelessWidget {
  const CountrySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: context.colors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(l10n.countrySriLanka, style: TextStyle(color: context.colors.ink)),
          ),
        ],
      ),
    );
  }
}
