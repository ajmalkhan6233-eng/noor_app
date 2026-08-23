// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Persistent top bar shown identically above every bottom-nav tab.
// Two rows so nothing can collide with the centered Allah calligraphy
// on narrow screens (360-430px): a top identity row (location pill,
// centered Allah + NOOR wordmark, settings gear) with only two small
// controls on either side of the mark, then a second row underneath
// for the theme toggle and language pills — previously all five
// controls fought for space in one Stack-over-Row, which on narrow
// screens let the right-side cluster (toggle + 3 language pills +
// gear) run into the centered wordmark. Lives above HomeDashboard's
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
  Size get preferredSize => const Size.fromHeight(104);

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
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                NoorWordmark(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LocationPill(),
                    SettingsGearButton(),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ThemeToggleButton(),
                SizedBox(width: 10),
                LanguagePills(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
