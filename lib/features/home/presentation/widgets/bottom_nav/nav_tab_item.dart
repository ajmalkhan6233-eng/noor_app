// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A single bottom-nav tab: the glyph itself paints its own glossy
// "orb" badge (see noor_icon_style.dart's paintNavOrbBadge) — active
// glows gold-rimmed and full color, inactive is a dim matte sphere.
// Split out of NoorBottomNav to keep both files under the project's
// line-count convention.

import 'package:flutter/material.dart';

import '../../../../../core/presentation/icons/noor_icon.dart';
import '../../../../../core/presentation/icons/noor_icon_type.dart';
import '../../../../../core/presentation/motion/motion.dart';
import '../../../../../core/utils/semantics_helpers.dart';
import '../../../../../core/constants/app_color_tokens.dart';

class NavTabItem extends StatelessWidget {
  const NavTabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final NoorIconType icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duration = Motion.effective(context, Motion.short);
    return Expanded(
      child: SemanticButton(
        label: label,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: duration,
              curve: Motion.curve,
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: NoorIcon(
                icon,
                color: active ? context.colors.gold : context.colors.sage,
                active: active,
                size: 40,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? context.colors.gold : context.colors.sage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
