// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Page-turn reader for "Read the full Quran". Pages come from
// FullQuranPaginator, which builds them progressively (and caches
// them), so the first page shows almost at once instead of after a
// whole-book measurement pass. A surah's name/audio header renders only
// on that surah's first page, and a page never spans two surahs.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/quran_ayah.dart';
import '../../data/quran_surah.dart';
import '../../logic/full_quran_paginator.dart';
import 'continuous_surah_text.dart';
import 'full_quran_page_header.dart';
import 'full_quran_page_splitter.dart';
import 'page_turn_transition.dart';

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
  final _paginator = FullQuranPaginator();
  bool _jumped = false;

  TextStyle _textStyle(BuildContext context) => TextStyle(
        fontFamily: AppTypography.arabicFamily,
        color: context.colors.ink,
        fontSize: 22 * widget.fontScale,
        height: 2.1,
      );

  @override
  void initState() {
    super.initState();
    _paginator.addListener(_onPagesChanged);
  }

  @override
  void dispose() {
    _paginator
      ..removeListener(_onPagesChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  // Shows pages as soon as they exist. When resuming at a saved
  // position, waits only until that page has been built.
  void _onPagesChanged() {
    if (!mounted) return;
    setState(() {});
    if (_jumped) return;
    final index = findInitialPageIndex(
      _paginator.pages,
      widget.initialSurahId,
      widget.initialAyahNumber,
    );
    if (widget.initialAyahNumber == null || index >= 0 || _paginator.done) {
      _jumped = true;
      if (index > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_controller.hasClients) _controller.jumpToPage(index);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = _textStyle(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _paginator.ensure(
            ayahs: widget.ayahs,
            surahs: widget.surahs,
            style: style,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fontScale: widget.fontScale,
          );
        });
        final pages = _paginator.pages;
        final waitingForResume = widget.initialAyahNumber != null && !_jumped;
        if (pages.isEmpty || waitingForResume) {
          return Center(child: CircularProgressIndicator(color: context.colors.gold));
        }
        return PageView.builder(
          controller: _controller,
          itemCount: pages.length,
          itemBuilder: (context, index) => _buildPage(pages[index], index),
        );
      },
    );
  }

  Widget _buildPage(BookPage page, int index) {
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
  }
}
