// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Page-turn reader for "Read the full Quran" (2026-09-04, direct
// request extending the per-surah reader's page-turn treatment here
// too — see paginated_surah_text.dart for the original). Pages are
// computed book-wide via full_quran_page_splitter.dart; a surah's
// name/audio header renders only on that surah's first page, and a
// page never spans two surahs.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../data/quran_ayah.dart';
import '../../data/quran_surah.dart';
import 'continuous_surah_text.dart';
import 'full_quran_page_header.dart';
import 'full_quran_page_splitter.dart';
import 'page_turn_transition.dart';
import '../../../../core/constants/app_color_tokens.dart';

class PaginatedFullQuranText extends StatefulWidget {
  const PaginatedFullQuranText({
    super.key,
    required this.ayahs,
    required this.surahs,
    required this.fontScale,
    required this.bookmarkedAyahNumbers,
    required this.onToggleBookmark,
    required this.ayahKeyFor,
    required this.playingSurahId,
    required this.onToggleAudio,
    this.initialSurahId,
    this.initialAyahNumber,
  });

  final List<QuranAyah> ayahs;
  final List<QuranSurah> surahs;
  final double fontScale;
  final Set<int> Function(int surahId) bookmarkedAyahNumbers;
  final void Function(int surahId, int ayahNumber) onToggleBookmark;
  final GlobalKey Function(int surahId, int ayahNumber) ayahKeyFor;
  final int? playingSurahId;
  final ValueChanged<int> onToggleAudio;

  /// Jumps straight to this ayah (last-read resume) instead of page 1.
  final int? initialSurahId;
  final int? initialAyahNumber;

  @override
  State<PaginatedFullQuranText> createState() => _PaginatedFullQuranTextState();
}

class _PaginatedFullQuranTextState extends State<PaginatedFullQuranText> {
  late final _controller = PageController(initialPage: 0);
  List<BookPage> _pages = const [];
  bool _initialPageSet = false;
  bool _isPaginating = false;

  // Memoized: repaginating the whole Quran on every rebuild (even a
  // routine ReadingPositionTracker update) froze the UI thread for
  // tens of seconds — the "gets stuck" bug found live 2026-09-04.
  double? _paginatedWidth;
  double? _paginatedHeight;
  double? _paginatedFontScale;
  int? _paginatedAyahCount;

  // Cached at the class level, not per State instance (2026-09-05 fix):
  // Navigator always creates a fresh State when this screen is pushed,
  // so the instance-level memoization above only ever helped within one
  // visit — leaving and reopening "Read the full Quran" re-ran the same
  // ~30s whole-book measurement pass every time ("took the same amount
  // of time to load back", direct report). Reused as long as the
  // layout size, font scale, and ayah count haven't actually changed;
  // invalidated automatically otherwise.
  static List<BookPage>? _cachedPages;
  static double? _cachedWidth;
  static double? _cachedHeight;
  static double? _cachedFontScale;
  static int? _cachedAyahCount;

  TextStyle _textStyle(BuildContext context) => TextStyle(
        fontFamily: AppTypography.arabicFamily,
        color: context.colors.ink,
        fontSize: 22 * widget.fontScale,
        height: 2.1,
      );

  @override
  void initState() {
    super.initState();
    if (_cachedPages != null &&
        _cachedFontScale == widget.fontScale &&
        _cachedAyahCount == widget.ayahs.length) {
      _pages = _cachedPages!;
      _paginatedWidth = _cachedWidth;
      _paginatedHeight = _cachedHeight;
      _paginatedFontScale = _cachedFontScale;
      _paginatedAyahCount = _cachedAyahCount;
      _initialPageSet = true;
      final pageIndex = findInitialPageIndex(_pages, widget.initialSurahId, widget.initialAyahNumber);
      if (pageIndex > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_controller.hasClients) _controller.jumpToPage(pageIndex);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _needsRepaginate(BoxConstraints constraints) {
    return _paginatedWidth != constraints.maxWidth ||
        _paginatedHeight != constraints.maxHeight ||
        _paginatedFontScale != widget.fontScale ||
        _paginatedAyahCount != widget.ayahs.length;
  }

  // Runs the whole-book measurement pass asynchronously instead of
  // inline during build (2026-09-05 fix — see full_quran_page_splitter's
  // own doc comment): a single first pass over ~6,236 ayahs still takes
  // real time even after the 2026-09-04 memoization fix stopped it from
  // repeating on every rebuild, and running that synchronously inside
  // LayoutBuilder's builder blocked the entire UI thread for it, which
  // read as "still gets stuck" even though it would eventually finish.
  Future<void> _startPaginating(BoxConstraints constraints, TextStyle style) async {
    if (_isPaginating) return;
    _isPaginating = true;
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    final fontScale = widget.fontScale;
    final ayahCount = widget.ayahs.length;

    final pages = await splitBookIntoPages(
      ayahs: widget.ayahs,
      surahs: widget.surahs,
      style: style,
      maxWidth: width,
      maxHeight: height,
    );
    if (!mounted) return;

    setState(() {
      _pages = pages;
      _paginatedWidth = width;
      _paginatedHeight = height;
      _paginatedFontScale = fontScale;
      _paginatedAyahCount = ayahCount;
      _isPaginating = false;
    });
    _cachedPages = pages;
    _cachedWidth = width;
    _cachedHeight = height;
    _cachedFontScale = fontScale;
    _cachedAyahCount = ayahCount;

    if (_initialPageSet) return;
    _initialPageSet = true;
    final pageIndex = findInitialPageIndex(_pages, widget.initialSurahId, widget.initialAyahNumber);
    if (pageIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) _controller.jumpToPage(pageIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_needsRepaginate(constraints) && !_isPaginating) {
          final style = _textStyle(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startPaginating(constraints, style);
          });
        }
        if (_pages.isEmpty) {
          return Center(child: CircularProgressIndicator(color: context.colors.gold));
        }
        return PageView.builder(
          controller: _controller,
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            final page = _pages[index];
            return PageTurnTransition(
              controller: _controller,
              index: index,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (page.isFirstPageOfSurah)
                      FullQuranPageHeader(
                        page: page,
                        isPlaying: widget.playingSurahId == page.surah.id,
                        onToggleAudio: () => widget.onToggleAudio(page.surah.id),
                      ),
                    ContinuousSurahText(
                      ayahs: page.ayahs,
                      fontScale: widget.fontScale,
                      bookmarkedAyahNumbers: widget.bookmarkedAyahNumbers(page.surah.id),
                      onToggleBookmark: (ayahNumber) => widget.onToggleBookmark(page.surah.id, ayahNumber),
                      ayahKeyFor: (ayahNumber) => widget.ayahKeyFor(page.surah.id, ayahNumber),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
