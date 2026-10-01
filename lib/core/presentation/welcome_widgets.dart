// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../constants/app_color_tokens.dart';
import '../constants/corner_radius.dart';
import '../utils/semantics_helpers.dart';
import '../../features/settings/data/app_locale.dart';

/// One line of the welcome screen's "why we ask" list.
class WelcomeReason extends StatelessWidget {
  const WelcomeReason({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(child: Icon(icon, color: colors.gold, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: colors.ink, height: 1.4))),
        ],
      ),
    );
  }
}

/// A language choice (a choice, not a permission).
class LocaleChoiceButton extends StatelessWidget {
  const LocaleChoiceButton({
    super.key,
    required this.option,
    required this.selected,
    required this.hint,
    required this.onTap,
  });

  final AppLocaleOption option;
  final bool selected;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SemanticButton(
      label: option.nativeName,
      hint: hint,
      checked: selected,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(context.radiusFor(10)),
          border: Border.all(color: selected ? colors.gold : colors.hairline),
        ),
        child: Text(
          option.nativeName,
          style: TextStyle(
            color: selected ? colors.paper : colors.ink,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
