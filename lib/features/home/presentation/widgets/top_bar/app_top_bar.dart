// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Persistent top bar shown identically above every bottom-nav tab —
// just the settings gear on the trailing edge. The Allah + NOOR
// wordmark used to sit centered here too; removed per explicit
// request (2026-08-24 live-device review) — it's still the first
// thing shown on the splash screen, just not repeated on every screen
// after that. Location, theme, and language all live in Settings only
// — this bar doesn't carry any of that either. Lives above
// HomeDashboard's FadeTabSwitcher so its own state survives tab
// switches.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'settings_gear_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: const SafeArea(
        bottom: false,
        child: Align(alignment: Alignment.centerRight, child: SettingsGearButton()),
      ),
    );
  }
}
