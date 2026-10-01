// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Edit (or remove) the name shown in Home's greeting. Kept on this
// device only; no account, nothing sent anywhere.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

class ProfileNameSection extends StatelessWidget {
  const ProfileNameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final name = state.settings.profileName?.trim() ?? '';
        final hasName = name.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SemanticButton(
              label: hasName ? '${l10n.settingsYourName}: $name' : l10n.settingsAddName,
              hint: l10n.settingsNameExplain,
              onTap: () => _edit(context, name),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: colors.gold),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hasName ? name : l10n.settingsAddName,
                        style: AppTypography.body(hasName ? colors.ink : colors.sage),
                      ),
                    ),
                    Icon(Icons.edit_outlined, size: 18, color: colors.gold),
                  ],
                ),
              ),
            ),
            Text(l10n.settingsNameExplain, style: AppTypography.caption(colors.sage)),
          ],
        );
      },
    );
  }

  Future<void> _edit(BuildContext context, String current) async {
    final cubit = context.read<SettingsCubit>();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _NameDialog(initial: current),
    );
    if (result != null) await cubit.setProfileName(result);
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial});

  final String initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return AlertDialog(
      backgroundColor: colors.card,
      title: Text(l10n.settingsYourName, style: AppTypography.bodyStrong(colors.ink)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 30,
        textInputAction: TextInputAction.done,
        style: AppTypography.body(colors.ink),
        decoration: InputDecoration(hintText: l10n.settingsNameFieldHint),
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        if (widget.initial.isNotEmpty)
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: Text(l10n.settingsRemoveName, style: AppTypography.body(colors.sage)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel, style: AppTypography.body(colors.sage)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(l10n.commonSave, style: AppTypography.body(colors.gold)),
        ),
      ],
    );
  }
}
