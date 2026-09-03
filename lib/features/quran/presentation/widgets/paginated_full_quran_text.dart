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
import 'full_quran_page_splitter.dart';
import 'page_turn_transition.dart';
import 'surah_audio_button.dart';
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

  /// Opens straight to the page containing this ayah (last-read
  /// resume) instead of always starting at page 1.
  final int? initialSurahId;
  final int? initialAyahNumber;

  @override
  State<PaginatedFullQuranText> createState() => _PaginatedFullQuranTextState();
}

class _PaginatedFullQuranTextState extends State<PaginatedFullQuranText> {
  late final _controller = PageController(initialPage: 0);
  List<BookPage> _pages = const [];
  bool _initialPageSet = false;

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

  void _paginate(BoxConstraints constraints, BuildContext context) {
    _pages = splitBookIntoPages(
      ayahs: widget.ayahs,
      surahs: widget.surahs,
      style: _textStyle(context),
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
    );
    if (_initialPageSet) return;
    _initialPageSet = true;
    final surahId = widget.initialSurahId;
    final ayahNumber = widget.initialAyahNumber;
    if (surahId == null || ayahNumber == null) return;
    final pageIndex = _pages.indexWhere(
      (p) => p.surah.id == surahId && p.ayahs.any((a) => a.ayahNumber == ayahNumber),
    );
    if (pageIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) _controller.jumpToPage(pageIndex);
      });
    }
  }

  Widget _pageHeader(BuildContext context, BookPage page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${page.surah.id}. ${page.surah.displayName}',
              style: AppTypography.sectionHeader(context.colors.sage).copyWith(color: context.colors.gold, fontSize: 20),
            ),
          ),
          SurahAudioButton(
            surahId: page.surah.id,
            isPlaying: widget.playingSurahId == page.surah.id,
            onToggle: () => widget.onToggleAudio(page.surah.id),
          ),
        ],
      ),
    );
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
                    if (page.isFirstPageOfSurah) _pageHeader(context, page),
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
