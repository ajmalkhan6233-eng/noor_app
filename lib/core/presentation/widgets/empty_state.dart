// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// "Nothing here yet" across the app: a small centred block floating
// directly on the background, never a full-screen filled card —
// emptiness should read as quiet, not as a missing feature.

import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: message,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: context.colors.sage, size: 32),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.sage, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
