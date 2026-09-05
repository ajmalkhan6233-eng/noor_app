// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Page-by-page reader for one surah (2026-09-01, direct request:
// "the turning page effect should come... page by page", replacing
// ContinuousSurahText's single long scroll). Pages are computed live
// from the actual viewport (surah_page_splitter.dart) — see that
// file's header for why these aren't real 604-page Mushaf page
// numbers. Each swipe applies a light 3D rotation so it reads as a
// page turning, not a flat slide.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../data/quran_ayah.dart';
import 'continuous_surah_text.dart';
import 'page_turn_transition.dart';
import 'surah_page_splitter.dart';
import '../../../../core/constants/app_color_tokens.dart';

class PaginatedSurahText extends StatefulWidget {
  const PaginatedSurahText({
    super.key,
    required this.ayahs,
    required this.fontScale,
    required this.bookmarkedAyahNumbers,
    required this.onToggleBookmark,
    required this.ayahKeyFor,
    this.initialAyahNumber,
  });

  final List<QuranAyah> ayahs;
  final double fontScale;
  final Set<int> bookmarkedAyahNumbers;
  final ValueChanged<int> onToggleBookmark;
  final GlobalKey Function(int ayahNumber) ayahKeyFor;

  /// Opens straight to the page containing this ayah (last-read
  /// resume) instead of always starting at page 1.
  final int? initialAyahNumber;

  @override
  State<PaginatedSurahText> createState() => _PaginatedSurahTextState();
}

class _PaginatedSurahTextState extends State<PaginatedSurahText> {
  late final _controller = PageController(initialPage: 0);
  List<List<QuranAyah>> _pages = const [];
  bool _initialPageSet = false;

  // Memoized the same way paginated_full_quran_text.dart's sibling
  // fix is — see that file's header for the real bug this class of
  // recompute-on-every-rebuild caused there. One surah's worth of
  // measurement is cheap enough that it was never visibly a problem
  // here, but re-measuring on every unrelated rebuild is still wasted
  // work, and keeping both readers consistent avoids the same trap
  // resurfacing if this surah reader is ever pointed at more text.
  double? _paginatedWidth;
  double? _paginatedHeight;
  double? _paginatedFontScale;
  int? _paginatedAyahCount;

  TextStyle _textStyle(BuildContext context) => TextStyle(
        fontFamily: AppTypography.arabicFamily,
        color: context.colors.ink,
        fontSize: 22 * widget.fontScale,
        height: 2.1,
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Rounded to the nearest logical pixel (2026-09-05 fix, matching
  // paginated_full_quran_text.dart's sibling fix): exact `==` on raw
  // constraints re-triggers on sub-pixel system-UI jitter alone, with
  // no real layout change.
  double _rounded(double value) => value.roundToDouble();

  void _paginate(BoxConstraints constraints, BuildContext context) {
    final width = _rounded(constraints.maxWidth);
    final height = _rounded(constraints.maxHeight);
    final unchanged = _paginatedWidth == width &&
        _paginatedHeight == height &&
        _paginatedFontScale == widget.fontScale &&
        _paginatedAyahCount == widget.ayahs.length;
    if (unchanged) return;

    _pages = splitIntoPages(
      ayahs: widget.ayahs,
      style: _textStyle(context),
      maxWidth: width,
      maxHeight: height,
    );
    _paginatedWidth = width;
    _paginatedHeight = height;
    _paginatedFontScale = widget.fontScale;
    _paginatedAyahCount = widget.ayahs.length;

    if (!_initialPageSet) {
      _initialPageSet = true;
      final target = widget.initialAyahNumber;
      if (target != null) {
        final pageIndex = _pages.indexWhere((p) => p.any((a) => a.ayahNumber == target));
        if (pageIndex > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_controller.hasClients) _controller.jumpToPage(pageIndex);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _paginate(constraints, context);
        if (_pages.isEmpty) return const SizedBox.shrink();
        return PageView.builder(
          controller: _controller,
          itemCount: _pages.length,
          itemBuilder: (context, index) => PageTurnTransition(
            controller: _controller,
            index: index,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ContinuousSurahText(
                ayahs: _pages[index],
                fontScale: widget.fontScale,
                bookmarkedAyahNumbers: widget.bookmarkedAyahNumbers,
                onToggleBookmark: widget.onToggleBookmark,
                ayahKeyFor: widget.ayahKeyFor,
              ),
            ),
          ),
        );
      },
    );
  }
}
