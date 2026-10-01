// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../core/constants/app_typography.dart';

/// One tappable row card on the About screen (privacy policy, help,
/// licences) — the same shape everywhere.
class AboutLinkCard extends StatelessWidget {
  const AboutLinkCard({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    required this.builder,
  });

  final IconData icon;
  final String label;
  final String hint;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: SemanticButton(
        label: label,
        hint: hint,
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: builder)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              ExcludeSemantics(child: Icon(icon, color: context.colors.gold)),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: AppTypography.body(context.colors.ink))),
            ],
          ),
        ),
      ),
    );
  }
}
