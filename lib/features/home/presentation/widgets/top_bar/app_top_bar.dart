// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Persistent top bar shown identically above every bottom-nav tab:
// location pill — centered Allah calligraphy + NOOR wordmark — theme
// toggle — language pills — settings gear. Lives above HomeDashboard's
// FadeTabSwitcher so its own state (and the PrayerCubit/SettingsCubit
// it and the tabs share) survives tab switches.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'language_pills.dart';
import 'location_pill.dart';
import 'noor_wordmark.dart';
import 'settings_gear_button.dart';
import 'theme_toggle_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationPill(),
                Row(
                  children: [
                    ThemeToggleButton(),
                    SizedBox(width: 10),
                    LanguagePills(),
                    SizedBox(width: 10),
                    SettingsGearButton(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
