// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Progress screen's headline card. Today's ring, percentage,
// streaks, weekly goal, a Week/Month view and badges, all read locally
// via ProgressCubit (nothing leaves the device).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../data/prayer_tracker_repository.dart';
import 'progress_card_body.dart';
import 'progress_cubit.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, this.repository});

  final PrayerTrackerRepository? repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressCubit(repository: repository)..load(),
      child: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) => AppCard(
          padding: const EdgeInsets.all(20),
          child: state.loading
              ? SizedBox(
                  height: 96,
                  child: Center(child: CircularProgressIndicator(color: context.colors.gold)),
                )
              : ProgressCardBody(state: state),
        ),
      ),
    );
  }
}
