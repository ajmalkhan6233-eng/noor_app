// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Adhan-preview + notification-bell icon cluster that leads each
// PrayerTimesList row. Split out to keep that file under the
// project's line-count limit.

import 'package:flutter/material.dart';

import 'adhan_preview_button.dart';
import 'prayer_notification_bell.dart';

class PrayerRowLeadingControls extends StatelessWidget {
  const PrayerRowLeadingControls({
    super.key,
    required this.name,
    required this.showBell,
    required this.bellOn,
    this.onToggleBell,
  });

  final String name;
  final bool showBell;
  final bool bellOn;
  final VoidCallback? onToggleBell;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sunrise has no Adhan, so AdhanPreviewButton would normally
        // render nothing here — but that shifts "Sunrise" left of
        // where the other names start. Reserve the same footprint
        // invisibly instead of hardcoding a width, so it can't drift
        // out of sync with the button's real size.
        if (name != 'Sunrise')
          AdhanPreviewButton(prayerName: name)
        else
          Visibility(
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: AdhanPreviewButton(prayerName: 'Fajr'),
          ),
        if (showBell)
          PrayerNotificationBell(
            prayerName: name,
            enabled: bellOn,
            onTap: onToggleBell!,
          ),
      ],
    );
  }
}
