// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Ramal/Idtiba explanation for the guide's Tawaf step. Reuses the
// exact same localisation strings the pilgrimage tracker's
// ReminderCard shows (`idtibaTitle`/`idtibaExplanation`/`ramalTitle`/
// `ramalExplanation`, backed by `pilgrimage/data/tawaf_reminders.dart`)
// so the guide and the live tracker never state the rule differently.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

class TawafEtiquetteNote extends StatelessWidget {
  const TawafEtiquetteNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rule(l10n.idtibaTitle, l10n.idtibaExplanation),
        const SizedBox(height: 8),
        _rule(l10n.ramalTitle, l10n.ramalExplanation),
        const SizedBox(height: 8),
        Text(l10n.womenTawafNote, style: const TextStyle(color: AppColors.sage, height: 1.4)),
      ],
    );
  }

  Widget _rule(String title, String explanation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 2),
        Text(explanation, style: const TextStyle(color: AppColors.sage, height: 1.4)),
      ],
    );
  }
}
