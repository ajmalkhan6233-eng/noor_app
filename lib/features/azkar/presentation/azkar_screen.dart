// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../logic/azkar_cubit/azkar_cubit.dart';
import 'widgets/azkar_category_selector.dart';

/// Azkar: a list of category rows (morning, evening, after prayer,
/// sleep, travel) — tap one to open its dhikr list. Restructured from
/// a horizontal chip selector + single flat list (2026-08-24
/// live-device review: "categorized, not one flat list") — see
/// AzkarCategoryScreen for what opens on tap.
class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarCubit()..init(),
      child: Scaffold(
        backgroundColor: AppColors.paper,
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.azkarScreenTitle)),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: AzkarCategorySelector(),
        ),
      ),
    );
  }
}
