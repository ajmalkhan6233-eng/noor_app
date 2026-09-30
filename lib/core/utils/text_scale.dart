// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/widgets.dart';

/// App-wide text boost (body text read too small on a real device,
/// 2026-08-26), applied on top of the OS accessibility scale but capped
/// so a 200% OS setting does not become 230% and overflow every layout.
const double appTextBoost = 1.15;
const double maxAppTextScale = 2.0;

TextScaler boostedTextScaler(TextScaler system) =>
    TextScaler.linear((system.scale(1.0) * appTextBoost).clamp(1.0, maxAppTextScale));
