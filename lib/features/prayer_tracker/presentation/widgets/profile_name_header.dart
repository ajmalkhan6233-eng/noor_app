// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The saved display name, shown prominently once a name exists — the
// AppBar title's new role once ProfileNameCard has collapsed away
// (see name_entry_transition.dart). Doubles as the edit affordance:
// tapping it re-opens the entry card, pre-filled with this name.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';

class ProfileNameHeader extends StatelessWidget {
  const ProfileNameHeader({super.key, required this.name, required this.onEdit});

  final String name;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: 'Your name: $name',
      hint: 'Double tap to edit your name',
      onTap: onEdit,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.heroDisplay(context.colors.ink).copyWith(fontSize: 28),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.edit_outlined, size: 16, color: context.colors.sage),
        ],
      ),
    );
  }
}
