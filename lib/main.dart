// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Entry point. Deliberately thin — all real setup happens in `app.dart`
// and the `core/` services, so this file never needs to grow.

import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoorApp());
}
