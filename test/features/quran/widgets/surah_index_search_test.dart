// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for the 2026-09-07 fix: search results used to be
// rendered inside StaggeredFadeIn, which restarts its fade animation
// from zero on every rebuild — since each keystroke emits a new
// QuranState with a freshly-built children list, results were
// invisible (opacity 0) the instant they appeared. Search results now
// render via a plain ListView.builder outside StaggeredFadeIn, so they
// must be immediately visible with no pump for an animation to settle.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/logic/quran_cubit/quran_cubit.dart';
import 'package:noor/features/quran/logic/quran_cubit/quran_state.dart';
import 'package:noor/features/quran/presentation/widgets/surah_index.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SizedBox(height: 800, child: child)),
  );
}

void main() {
  testWidgets('search results render immediately, with no fade-in delay', (
    tester,
  ) async {
    final cubit = QuranCubit();
    addTearDown(cubit.close);
    final state = const QuranState().copyWith(
      isLoading: false,
      searchQuery: 'Rahman',
      searchResults: [
        QuranAyah(surahId: 1, ayahNumber: 1, arabicText: 'بِسْمِ ٱللَّهِ'),
      ],
    );

    await tester.pumpWidget(
      _wrap(
        BlocProvider<QuranCubit>.value(
          value: cubit,
          child: SurahIndex(state: state),
        ),
      ),
    );
    // Deliberately no further pump — StaggeredFadeIn's bug meant the
    // result was present but invisible until several animation frames
    // ran. A single pumpWidget frame must already show it.

    expect(find.text('بِسْمِ ٱللَّهِ'), findsOneWidget);
  });

  testWidgets('empty search results show a message, not a blank list', (
    tester,
  ) async {
    final cubit = QuranCubit();
    addTearDown(cubit.close);
    final state = const QuranState().copyWith(
      isLoading: false,
      searchQuery: 'zzz-no-match',
      searchResults: const [],
    );

    await tester.pumpWidget(
      _wrap(
        BlocProvider<QuranCubit>.value(
          value: cubit,
          child: SurahIndex(state: state),
        ),
      ),
    );

    expect(find.text('No results found.'), findsOneWidget);
  });
}
