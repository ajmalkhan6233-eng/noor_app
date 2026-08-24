// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Home's top card. The "Assalamu Alaikum" greeting fades in once on
// open, holds briefly, then fades out and collapses — a one-time
// greeting, not something permanently taking up space every time this
// screen is glanced at (2026-08-24 live-device review). What stays
// permanently is a small compact row: the Hijri date pill and the
// Gregorian date, both shrunk down from their previous size — this
// card's job now is "confirm today's date", not carry a headline.

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HeroCard extends StatefulWidget {
  const HeroCard({super.key, required this.hijriOffsetDays});

  final int hijriOffsetDays;

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _greetingOpacity;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _greetingOpacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    // A real cancelable Timer, not Future.delayed — a pending
    // Future.delayed left running when this widget is torn down
    // (e.g. switching tabs mid-hold) fails flutter_test's "no pending
    // timers" invariant even with the mounted guard, since the timer
    // itself is still scheduled either way.
    _holdTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hijri = HijriDate.fromGregorian(DateTime.now(), offsetDays: widget.hijriOffsetDays);
    final dateSubtitle = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(DateTime.now());

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => _controller.value == 0
                ? const SizedBox.shrink()
                : ClipRect(
                    child: Align(
                      heightFactor: _controller.value,
                      child: Opacity(opacity: _greetingOpacity.value, child: child),
                    ),
                  ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                l10n.assalamuAlaikumGreeting,
                style: const TextStyle(
                  fontFamily: AppTypography.displayFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  dateSubtitle,
                  style: AppTypography.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.brightness_2_outlined, color: AppColors.gold, size: 12),
                    const SizedBox(width: 4),
                    Text(hijri.formatted, style: AppTypography.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
