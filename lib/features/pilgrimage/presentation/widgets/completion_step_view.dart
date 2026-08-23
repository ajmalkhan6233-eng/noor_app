// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Simple confirmation once a session is marked complete, showing the
// pilgrim's updated lifetime Umrah/Hajj counts. A single particle
// burst plays once behind the check-circle icon when this screen
// first appears — the clearest "moment of completion" in the app.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/effects/particle_burst.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/pilgrim_profile.dart';
import '../../data/pilgrimage_session.dart';

class CompletionStepView extends StatefulWidget {
  const CompletionStepView({super.key, required this.profile, required this.session});

  final PilgrimProfile profile;
  final PilgrimageSession? session;

  @override
  State<CompletionStepView> createState() => _CompletionStepViewState();
}

class _CompletionStepViewState extends State<CompletionStepView> {
  final _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final iconContext = _iconKey.currentContext;
      if (iconContext != null) ParticleBurst.play(iconContext);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final type = widget.session?.type ?? PilgrimageType.umrah;
    final umrahCount = widget.profile.totalUmrahCompleted + (type == PilgrimageType.umrah ? 1 : 0);
    final hajjCount = widget.profile.totalHajjCompleted + (type == PilgrimageType.hajj ? 1 : 0);
    final typeLabel = type == PilgrimageType.umrah ? l10n.umrahLabel : l10n.hajjLabel;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, key: _iconKey, color: AppColors.gold, size: 64),
            const SizedBox(height: 16),
            Text(l10n.completionScreenTitle, style: const TextStyle(color: AppColors.ink, fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(l10n.completionMessage(typeLabel), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.sage)),
            const SizedBox(height: 24),
            Text(l10n.completionUmrahCountLabel(umrahCount), style: const TextStyle(color: AppColors.ink)),
            Text(l10n.completionHajjCountLabel(hajjCount), style: const TextStyle(color: AppColors.ink)),
            const SizedBox(height: 24),
            SemanticButton(
              label: l10n.doneButtonLabel,
              hint: l10n.doneButtonHint,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(12)),
                child: Text(l10n.doneButtonLabel, style: const TextStyle(color: AppColors.card, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
