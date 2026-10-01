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
import '../../logic/surah_paginator.dart';
import 'continuous_surah_text.dart';
import 'page_turn_transition.dart';
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
  final _paginator = SurahPaginator();
  bool _jumped = false;

  TextStyle _textStyle(BuildContext context) => TextStyle(
        fontFamily: AppTypography.arabicFamily,
        color: context.colors.ink,
        fontSize: AppTypography.quranSize * widget.fontScale,
        height: AppTypography.quranHeight,
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

  void _onPagesChanged() {
    if (!mounted) return;
    setState(() {});
    if (_jumped) return;
    final target = widget.initialAyahNumber;
    if (target == null) {
      _jumped = true;
      return;
    }
    final index = _paginator.pageIndexOf(target);
    if (index >= 0 || _paginator.done) {
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
        // Pagination starts after this frame: it notifies listeners.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _paginator.ensure(
            ayahs: widget.ayahs,
            style: style,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fontScale: widget.fontScale,
          );
        });
        final pages = _paginator.pages;
        // Resuming mid-surah: wait (briefly) until the saved page exists
        // so the reader does not flash page 1 first.
        final waitingForResume = widget.initialAyahNumber != null && !_jumped;
        if (pages.isEmpty || waitingForResume) {
          return Center(child: CircularProgressIndicator(color: context.colors.gold));
        }
        return PageView.builder(
          controller: _controller,
          itemCount: pages.length,
          itemBuilder: (context, index) => PageTurnTransition(
            controller: _controller,
            index: index,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ContinuousSurahText(
                ayahs: pages[index],
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
