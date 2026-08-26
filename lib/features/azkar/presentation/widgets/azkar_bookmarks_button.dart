// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of azkar_screen.dart to stay under the 150-line-per-file
// rule. Mirrors the Quran tab's bookmark icon in its own app bar.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/azkar_cubit/azkar_cubit.dart';
import '../azkar_bookmarks_screen.dart';

class AzkarBookmarksButton extends StatelessWidget {
  const AzkarBookmarksButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AzkarCubit>();
    return IconButton(
      icon: const Icon(Icons.bookmark_border),
      tooltip: 'Bookmarks',
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const AzkarBookmarksScreen(),
          ),
        ),
      ),
    );
  }
}
