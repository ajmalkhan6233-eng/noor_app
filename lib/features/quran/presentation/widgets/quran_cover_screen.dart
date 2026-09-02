// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Quran section's front cover — shown once per app session,
// before the surah index, mirroring a physical Mus'haf's cover page.
// No cover image asset exists in this project, so this is a
// typographic + geometric cover using existing design tokens: the
// already-verified Bismillah string (AppStrings.splashGreeting, the
// same one the splash uses — reused, not retyped) plus the localized
// section title. No new Quranic/Arabic text is generated here.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'quran_cover_ornament_painter.dart';

class QuranCoverScreen extends StatelessWidget {
  const QuranCoverScreen({super.key, required this.onEnter});

  final VoidCallback onEnter;

  static const double _swipeVelocityThreshold = 120;

  void _maybeEnterOnSwipe(DragEndDetails details) {
    if ((details.primaryVelocity ?? 0).abs() > _swipeVelocityThreshold) {
      onEnter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Semantics(
      button: true,
      label: l10n.quranCoverSemanticsLabel,
      hint: l10n.quranCoverSemanticsHint,
      onTap: onEnter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onEnter,
        onVerticalDragEnd: _maybeEnterOnSwipe,
        onHorizontalDragEnd: _maybeEnterOnSwipe,
        child: Container(
          color: colors.paper,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          child: CustomPaint(
            painter: QuranCoverOrnamentPainter(gold: colors.gold, cyan: colors.accentSecondary),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
              child: StaggeredFadeIn(
                children: [
                  Text(
                    AppStrings.splashGreeting,
                    textAlign: TextAlign.center,
                    style: AppTypography.arabic(colors.gold).copyWith(fontSize: 26),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      l10n.quranScreenTitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.heroDisplay(colors.ink),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      l10n.quranCoverTapToBegin,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption(colors.sage),
                    ),
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
