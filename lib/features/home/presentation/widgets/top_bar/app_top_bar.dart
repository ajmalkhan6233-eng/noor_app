// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Persistent top bar shown identically above every bottom-nav tab: a
// single row, centered Allah + NOOR wordmark, settings gear on the
// trailing edge. Location, theme, and language all live in Settings
// only now — this bar used to also carry a location pill and a whole
// second row of theme/language controls, which duplicated Settings
// and crowded the one thing this bar actually needs to show clearly.
// Lives above HomeDashboard's FadeTabSwitcher so its own state
// survives tab switches.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'noor_wordmark.dart';
import 'settings_gear_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: SafeArea(
        bottom: false,
        child: const Stack(
          alignment: Alignment.center,
          children: [
            NoorWordmark(),
            Align(alignment: Alignment.centerRight, child: SettingsGearButton()),
          ],
        ),
      ),
    );
  }
}
