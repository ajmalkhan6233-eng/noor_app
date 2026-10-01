// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The surah list must build only what is on screen. The old list built
// all 114 tiles inside staggered fades and parallax wrappers.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/quran/data/quran_surah.dart';
import 'package:noor/features/quran/logic/quran_cubit/quran_cubit.dart';
import 'package:noor/features/quran/logic/quran_cubit/quran_state.dart';
import 'package:noor/features/quran/presentation/widgets/surah_index.dart';
import 'package:noor/features/quran/presentation/widgets/surah_list_tile.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('only the visible surah tiles are built, and it is ready in one frame', (tester) async {
    final cubit = QuranCubit();
    addTearDown(cubit.close);
    final state = const QuranState().copyWith(
      isLoading: false,
      surahs: [for (var i = 1; i <= 114; i++) QuranSurah(id: i, ayahCount: 7, nameEnglish: 'Surah $i')],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 800,
            child: BlocProvider<QuranCubit>.value(value: cubit, child: SurahIndex(state: state)),
          ),
        ),
      ),
    );

    final built = find.byType(SurahListTile).evaluate().length;
    expect(built, greaterThan(0));
    expect(built, lessThan(40), reason: 'a lazy list builds far fewer than 114 tiles');
  });
}
