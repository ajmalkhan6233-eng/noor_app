// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Qibla screen: dial + readout, built from plain widgets. Always
// shows something useful: with a compass the needle follows the phone;
// without one (or while it is silent) a static arrow and the bearing.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_color_tokens.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../logic/qibla_compass_cubit.dart';
import '../logic/qibla_compass_state.dart';
import 'widgets/qibla_dial.dart';
import 'widgets/qibla_readout.dart';

class QiblaCompassScreen extends StatelessWidget {
  const QiblaCompassScreen({super.key, this.cubit});

  /// Injected by tests; the app builds its own.
  final QiblaCompassCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = BlocBuilder<QiblaCompassCubit, QiblaCompassState>(
      builder: (context, state) {
        if (state.loading || state.bearing == null) {
          return Center(child: CircularProgressIndicator(color: context.colors.gold));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: Column(
            children: [
              const SizedBox(height: 8),
              QiblaDial(
                heading: state.hasHeading ? state.heading : null,
                needleAngle: state.needleAngle ?? 0,
                aligned: state.aligned,
              ),
              const SizedBox(height: 24),
              QiblaReadout(
                state: state,
                onAllowLocation: () => context.read<QiblaCompassCubit>().useRealLocation(),
              ),
            ],
          ),
        );
      },
    );
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(title: Text(l10n.qiblaScreenTitle)),
      body: SafeArea(
        child: cubit != null
            ? BlocProvider.value(value: cubit!, child: body)
            : BlocProvider(create: (_) => QiblaCompassCubit()..start(), child: body),
      ),
    );
  }
}
