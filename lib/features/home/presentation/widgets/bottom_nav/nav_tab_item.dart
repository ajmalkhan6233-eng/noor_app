// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A single bottom-nav tab: active shows the icon inside a glowing
// gold circle with a gold label; inactive shows a plain outline icon
// with a gray label. Split out of NoorBottomNav to keep both files
// under the project's line-count convention.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/presentation/motion/motion.dart';
import '../../../../../core/utils/semantics_helpers.dart';

class NavTabItem extends StatelessWidget {
  const NavTabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.showLabel = true,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  /// False in the nav dock's compact (scrolled-down) state — icon
  /// only, no [Expanded] wrapper, since the compact dock sizes itself
  /// to content (MainAxisSize.min) rather than filling the width.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final duration = Motion.effective(context, Motion.short);
    final content = SemanticButton(
      label: label,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: showLabel ? 0 : 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: duration,
              curve: Motion.curve,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? AppColors.gold : Colors.transparent,
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.55),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: active ? AppColors.paper : AppColors.sage,
                size: 22,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? AppColors.gold : AppColors.sage,
                ),
              ),
            ],
          ],
        ),
      ),
    );
    return showLabel ? Expanded(child: content) : content;
  }
}
