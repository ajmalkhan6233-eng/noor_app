// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../core/constants/app_color_tokens.dart';
import '../../../core/constants/corner_radius.dart';
import '../../../core/constants/app_typography.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, 
    required this.icon,
    required this.label,
    required this.busy,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SemanticButton(
        label: label,
        onTap: busy ? () {} : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: context.colors.gold,
            borderRadius: BorderRadius.circular(context.radiusFor(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.paper),
                )
              else
                Icon(icon, color: context.colors.paper, size: 18),
              const SizedBox(width: 8),
              Text(label, style: AppTypography.bodyStrong(context.colors.paper)),
            ],
          ),
        ),
      ),
    );
  }
}
