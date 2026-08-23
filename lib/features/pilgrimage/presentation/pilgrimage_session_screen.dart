// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Single host for the whole session flow (setup -> Tawaf -> Sa'i ->
// completion), all sharing one `PilgrimageSessionCubit`. Steps swap
// as plain conditional content in one screen — not separate pushed
// routes — since a `BlocProvider` on one route is never an ancestor
// of a widget tree pushed onto a new route. This also gives automatic
// resume for free: whatever step `load()` restores is simply what
// renders first.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/pilgrim_profile.dart';
import '../data/pilgrimage_session.dart';
import '../logic/session_cubit/session_cubit.dart';
import '../logic/session_cubit/session_state.dart';
import 'widgets/completion_step_view.dart';
import 'widgets/new_session_form.dart';
import 'widgets/sai_step_view.dart';
import 'widgets/tawaf_step_view.dart';

class PilgrimageSessionScreen extends StatelessWidget {
  const PilgrimageSessionScreen({super.key, required this.profile});

  final PilgrimProfile profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PilgrimageSessionCubit()..load(profile.id!),
      child: _PilgrimageSessionView(profile: profile),
    );
  }
}

class _PilgrimageSessionView extends StatelessWidget {
  const _PilgrimageSessionView({required this.profile});

  final PilgrimProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(_titleFor(l10n))),
      body: BlocBuilder<PilgrimageSessionCubit, PilgrimageSessionState>(
        builder: (context, state) => _body(context, state),
      ),
    );
  }

  String _titleFor(AppLocalizations l10n) => l10n.pilgrimageLabel;

  Widget _body(BuildContext context, PilgrimageSessionState state) {
    switch (state.status) {
      case PilgrimageSessionStatus.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.gold));
      case PilgrimageSessionStatus.needsSetup:
        return Padding(
          padding: const EdgeInsets.all(24),
          child: NewSessionForm(profile: profile),
        );
      case PilgrimageSessionStatus.completed:
        return CompletionStepView(profile: profile, session: state.session);
      case PilgrimageSessionStatus.active:
        final step = state.session?.currentStep ?? PilgrimageStep.tawaf;
        return step == PilgrimageStep.sai
            ? SaiStepView(profile: profile, state: state)
            : TawafStepView(profile: profile, state: state);
    }
  }
}
