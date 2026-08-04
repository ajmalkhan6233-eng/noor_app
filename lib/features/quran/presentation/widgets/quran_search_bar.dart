// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../logic/quran_cubit/quran_cubit.dart';

/// Search over the diacritic-stripped Arabic text column.
class QuranSearchBar extends StatelessWidget {
  const QuranSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Search the Quran',
      child: TextField(
        style: const TextStyle(color: AppColors.parchment),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: AppColors.sage),
          hintText: 'Search…',
          hintStyle: TextStyle(color: AppColors.sage),
        ),
        onChanged: (query) => context.read<QuranCubit>().search(query),
      ),
    );
  }
}
