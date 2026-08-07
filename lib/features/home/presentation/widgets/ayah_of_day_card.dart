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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../quran/data/quran_ayah.dart';
import '../../../quran/data/quran_repository.dart';
import '../../../quran/data/quran_surah.dart';
import '../../../quran/presentation/quran_screen.dart';

class AyahOfDayCard extends StatelessWidget {
  AyahOfDayCard({super.key, QuranRepository? repository})
    : _repository = repository ?? QuranRepository();

  final QuranRepository _repository;

  Future<(QuranAyah?, List<QuranSurah>)> _load() async {
    final ayah = await _repository.ayahOfTheDay();
    final surahs = await _repository.surahs();
    return (ayah, surahs);
  }

  void _copy(BuildContext context, QuranAyah ayah) {
    final l10n = AppLocalizations.of(context)!;
    final text = [ayah.arabicText, if (ayah.translation != null) ayah.translation!].join('\n\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedConfirmationLabel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<(QuranAyah?, List<QuranSurah>)>(
      future: _load(),
      builder: (context, snapshot) {
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
              if (ayah == null)
                Text(
                  l10n.guideTextNotLoadedMessage,
                  style: const TextStyle(color: AppColors.sage, fontStyle: FontStyle.italic),
                )
              else ...[
                _reference(ayah, surahs),
                const SizedBox(height: 12),
                Text(ayah.arabicText, textAlign: TextAlign.right, style: AppTypography.arabic),
                if (ayah.translation != null && ayah.translation!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(ayah.translation!, style: AppTypography.caption),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    SemanticButton(
                      label: l10n.copyLabel,
                      onTap: () => _copy(context, ayah),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.copy_outlined, color: AppColors.gold, size: 16),
                          const SizedBox(width: 4),
                          Text(l10n.copyLabel, style: const TextStyle(color: AppColors.gold)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _fullQuranCta(context, l10n),
                  ],
                ),
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

  Widget _fullQuranCta(BuildContext context, AppLocalizations l10n) {
    return SemanticButton(
      label: l10n.fullQuranCtaLabel,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const QuranScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.gold, AppColors.accentSecondary],
          ),
        ),
        child: Text(
          l10n.fullQuranCtaLabel,
          style: const TextStyle(color: AppColors.paper, fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    );
  }
}
