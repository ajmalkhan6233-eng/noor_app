// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 2 of the UI Structure Pass: Home | Prayer Times | Al Quran |
// Duas & Dhikr | More, with the active tab shown as a glowing gold
// circular highlight instead of BottomNavigationBar's default flat
// color swap. Morphs between a full-width bar (labels visible) and a
// compact centred pill (icons only) as [expanded] changes — see
// home_dashboard.dart's scroll listener, which drives that flag.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/presentation/motion/motion.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import 'nav_tab_item.dart';

class NoorBottomNav extends StatelessWidget {
  const NoorBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.expanded = true,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool expanded;

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
    final reduced = Motion.reduced(context);
    final duration = reduced ? Duration.zero : const Duration(milliseconds: 380);

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: expanded ? 0 : 10,
          ),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.elasticOut,
            width: expanded ? double.infinity : tabs.length * 56.0,
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: expanded ? 0 : 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(expanded ? 0 : 28),
              border: expanded
                  ? const Border(top: BorderSide(color: AppColors.hairline))
                  : Border.all(color: AppColors.hairline),
              boxShadow: expanded
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.paper.withValues(alpha: 0.6),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: AnimatedSize(
              duration: duration,
              curve: Curves.easeOutCubic,
              child: Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    NavTabItem(
                      icon: tabs[i].$1,
                      label: tabs[i].$2,
                      active: i == selectedIndex,
                      showLabel: expanded,
                      onTap: () => onTap(i),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
