// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 2 of the UI Structure Pass: Home | Prayer Times | Al Quran |
// Duas & Dhikr | More, with the active tab shown as a glowing gold
// circular highlight instead of BottomNavigationBar's default flat
// color swap.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import 'nav_tab_item.dart';

class NoorBottomNav extends StatelessWidget {
  const NoorBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tabs = [
      (Icons.home_outlined, l10n.homeTab),
      (Icons.access_time, l10n.prayerTimesScreenTitle),
      (Icons.menu_book_outlined, l10n.quranTabLabel),
      (Icons.self_improvement_outlined, l10n.duasTabLabel),
      (Icons.more_horiz, l10n.moreTab),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              NavTabItem(
                icon: tabs[i].$1,
                label: tabs[i].$2,
                active: i == selectedIndex,
                onTap: () => onTap(i),
              ),
          ],
        ),
      ),
    );
  }
}
