// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3's Ayah of the Day card. Only ever shows text that came
// from QuranRepository — which only ever returns a SHA-256-verified
// Tanzil import — so there is no "not loaded" fallback text hand-typed
// here beyond the app's standard message.
//
// Scope note (deliberate, confirmed with the user): the original spec
// also called for a mood tag, a transliteration line, and an EN/TA/SI
// language toggle. None of those have verified source data yet — no
// transliteration column exists, and only the English translation is
// imported — so all three are omitted rather than invented. Revisit
// once transliteration + TA/SI translation sourcing is done.
//
// The Copy button and "Full Quran" CTA that used to sit under the
// ayah were removed (2026-08-24 live-device review) — this card is
// meant as a quick daily read, not another entry point into the
// reader (that already exists on the Al Quran tab itself).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../quran/data/quran_ayah.dart';
import '../../../quran/data/quran_import_service.dart';
import '../../../quran/data/quran_repository.dart';
import '../../../quran/data/quran_surah.dart';

class AyahOfDayCard extends StatefulWidget {
  const AyahOfDayCard({
    super.key,
    QuranRepository? repository,
    QuranImportService? importService,
  }) : _repository = repository,
       _importService = importService;

  final QuranRepository? _repository;
  final QuranImportService? _importService;

  @override
  State<AyahOfDayCard> createState() => _AyahOfDayCardState();
}

class _AyahOfDayCardState extends State<AyahOfDayCard> {
  late final QuranRepository _repository = widget._repository ?? QuranRepository();
  late final QuranImportService _importService =
      widget._importService ?? QuranImportService();

  // Created once here rather than inline in build()'s FutureBuilder —
  // a FutureBuilder(future: _load()) directly in build() creates a
  // brand-new Future (and re-queries the database) on every rebuild,
  // not just the first. See noor-animation-performance.
  late final Future<(QuranAyah?, List<QuranSurah>)> _future = _load();

  Future<(QuranAyah?, List<QuranSurah>)> _load() async {
    // Home may render before the user has ever opened the Al Quran
    // tab, so the DB import can't be assumed done — ensure it here too
    // rather than depending on QuranCubit.init() having already run.
    await _importService.ensureImported();
    final ayah = await _repository.ayahOfTheDay();
    final surahs = await _repository.surahs();
    return (ayah, surahs);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<(QuranAyah?, List<QuranSurah>)>(
      future: _future,
      builder: (context, snapshot) {
        final stillLoading = snapshot.connectionState != ConnectionState.done;
        final ayah = snapshot.data?.$1;
        final surahs = snapshot.data?.$2 ?? const <QuranSurah>[];

        return AppCard(
          padding: const EdgeInsets.all(20),
          borderColor: AppColors.goldBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.ayahOfTheDayTitle, style: AppTypography.sectionHeader),
              const SizedBox(height: 12),
              if (stillLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
                    ),
                  ),
                )
              else if (ayah == null)
                Text(
                  l10n.guideTextNotLoadedMessage,
                  style: const TextStyle(color: AppColors.sage, fontStyle: FontStyle.italic),
                )
              else ...[
                _reference(ayah, surahs),
                const SizedBox(height: 12),
                Text(
                  ayah.arabicText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTypography.arabic,
                ),
                if (ayah.translation != null && ayah.translation!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(ayah.translation!, style: AppTypography.caption),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _reference(QuranAyah ayah, List<QuranSurah> surahs) {
    final matches = surahs.where((s) => s.id == ayah.surahId);
    final surah = matches.isEmpty ? null : matches.first;
    final name = surah?.nameEnglish ?? surah?.nameTranslit ?? 'Surah ${ayah.surahId}';
    return Text(
      '$name ${ayah.surahId}:${ayah.ayahNumber}',
      style: const TextStyle(color: AppColors.sage, fontSize: 12, letterSpacing: 0.4),
    );
  }
}
