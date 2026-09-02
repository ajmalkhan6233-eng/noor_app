// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of progress_screen.dart to stay under the 150-line-per-
// file rule. An optional display name (never an account, never sent
// anywhere) — a stable controller/focus node owned here, not rebuilt
// inline in build() (that earlier bug recreated the TextEditingController
// on every SettingsCubit rebuild, including the one setProfileName
// itself triggers). Saves on both the keyboard's done key and on
// losing focus.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';

class ProfileNameCard extends StatefulWidget {
  const ProfileNameCard({super.key, this.onSaved});

  /// Called right after a save fires (checkmark tap, submit, or losing
  /// focus) — lets the caller know a save happened, not what was saved.
  final VoidCallback? onSaved;

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
                    onPressed: () {
                      _saveName();
                      _nameFocusNode.unfocus();
                    },
                  ),
                ),
                onSubmitted: (_) {
                  _saveName();
                  _nameFocusNode.unfocus();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
