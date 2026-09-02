// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of progress_screen.dart to stay under the 150-line-per-
// file rule. An optional display name (never an account, never sent
// anywhere) — a stable controller/focus node owned here, not rebuilt
// inline in build() (that earlier bug recreated the TextEditingController
// on every SettingsCubit rebuild, including the one setProfileName
// itself triggers). The checkmark and the keyboard's done key both
// just unfocus the field — _saveName() itself only ever runs from the
// focus-loss listener below, so it (and the haptic tap it fires) never
// double-fires for a single save.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';

class ProfileNameCard extends StatefulWidget {
  const ProfileNameCard({super.key, this.onSaved, this.hapticService = const HapticService()});

  /// Called right after a save fires (checkmark tap, submit, or losing
  /// focus) — lets the caller know a save happened, not what was saved.
  final VoidCallback? onSaved;

  final HapticService hapticService;

  @override
  State<ProfileNameCard> createState() => _ProfileNameCardState();
}

class _ProfileNameCardState extends State<ProfileNameCard> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  var _nameSeeded = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) _saveName();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _saveName() {
    context.read<SettingsCubit>().setProfileName(_nameController.text.trim());
    // Fired here, alongside onSaved, so it lands at the same instant
    // the card starts its dismiss transition (name_entry_transition.dart)
    // rather than before it. A light tap, same as a goal tick — this
    // can fire again on every future edit (tap the name header to
    // re-open the card), so it stays a routine confirmation rather
    // than milestonePulse()'s heavier one-time-event feel.
    widget.hapticService.tap();
    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        // Seed the controller from persisted state exactly once — after
        // that, the field is the source of truth so an in-flight edit
        // is never clobbered by a rebuild from an unrelated cubit
        // change.
        if (!_nameSeeded) {
          _nameController.text = state.settings.profileName ?? '';
          _nameSeeded = true;
        }
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your name (kept on this device only)', style: AppTypography.caption(context.colors.sage)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                style: TextStyle(color: context.colors.ink),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Add a name',
                  hintStyle: TextStyle(color: context.colors.sage),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check, color: context.colors.gold),
                    tooltip: 'Save name',
                    // Just unfocus — the listener below calls _saveName()
                    // on focus loss, so calling it here too used to save
                    // (and fire the haptic) twice per tap.
                    onPressed: _nameFocusNode.unfocus,
                  ),
                ),
                onSubmitted: (_) => _nameFocusNode.unfocus(),
              ),
            ],
          ),
        );
      },
    );
  }
}
