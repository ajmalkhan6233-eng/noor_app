// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/quran_cubit/quran_cubit.dart';

/// Search over the diacritic-stripped Arabic text column.
class QuranSearchBar extends StatelessWidget {
  const QuranSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      textField: true,
      label: l10n.searchQuranSemanticLabel,
      child: TextField(
        style: const TextStyle(color: AppColors.ink),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: AppColors.sage),
          hintText: l10n.searchHintText,
          hintStyle: const TextStyle(color: AppColors.sage),
        ),
        onChanged: (query) => context.read<QuranCubit>().search(query),
      ),
    );
  }
}
