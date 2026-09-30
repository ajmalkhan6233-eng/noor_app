// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../core/constants/app_color_tokens.dart';
import '../../../core/constants/corner_radius.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({super.key, 
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SemanticButton(
        label: label,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: filled ? context.colors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(context.radiusFor(12)),
            border: filled ? null : Border.all(color: context.colors.goldBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: filled ? context.colors.paper : context.colors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: filled ? context.colors.paper : context.colors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
