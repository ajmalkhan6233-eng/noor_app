// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A hand-rolled chip instead of Material's ChoiceChip — Chip pulls in
// M3 elevation tinting and defaults to a solid fill we don't want.
// Gold is punctuation: selected chips get a hairline gold border and
// gold text, never a solid gold fill.

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.semanticLabel,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.gold : AppColors.hairline,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.gold : AppColors.sage,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
