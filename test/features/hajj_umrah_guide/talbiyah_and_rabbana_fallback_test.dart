// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// TalbiyahCard and RabbanaAyahCard must show the standard "not loaded"
// message whenever their source (asset checksum / Quran import)
// hasn't resolved to real text — never invented or hard-coded text.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/hajj_umrah_guide/data/talbiyah_entry.dart';
import 'package:noor/features/hajj_umrah_guide/data/talbiyah_repository.dart';
import 'package:noor/features/hajj_umrah_guide/presentation/widgets/rabbana_ayah_card.dart';
import 'package:noor/features/hajj_umrah_guide/presentation/widgets/talbiyah_card.dart';
import 'package:noor/features/quran/data/quran_ayah.dart';
import 'package:noor/features/quran/data/quran_repository.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

class _EmptyTalbiyahRepository extends TalbiyahRepository {
  const _EmptyTalbiyahRepository();

  @override
  Future<TalbiyahEntry?> load() async => null;
}

class _EmptyQuranRepository extends QuranRepository {
  @override
  Future<QuranAyah?> singleAyah(int surahId, int ayahNumber) async => null;
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('TalbiyahCard falls back when the asset is not verified', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const TalbiyahCard(repository: _EmptyTalbiyahRepository())),
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.guideTextNotLoadedMessage), findsOneWidget);
  });

  testWidgets('RabbanaAyahCard falls back when the Quran is not imported', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(RabbanaAyahCard(repository: _EmptyQuranRepository())),
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.guideTextNotLoadedMessage), findsOneWidget);
  });
}
