// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Large centered screen title, added 2026-08-30 (master directive
// item 8: "large, centered, alive header" instead of the plain AppBar
// title this screen had). Reuses [GlowHeroTitle] — the same large,
// gold, breathing-glow treatment now shared with the Prayer Times
// header (see collapsing_scaffold.dart) — so this reads as the same
// visual language as the rest of the app rather than a one-off
// treatment. "Alive" here means it enters with the same
// [StaggeredFadeIn] motion as the rest of the screen (added at the
// call site) plus that slow, ambient glow.

import 'package:flutter/material.dart';
import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/widgets/glow_hero_title.dart';

class AzkarHeader extends StatelessWidget {
  const AzkarHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Center(child: GlowHeroTitle(title, color: context.colors.gold)),
    );
  }
}
