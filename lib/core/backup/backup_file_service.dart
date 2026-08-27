// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The only file in the backup feature that touches the OS: writing
// the encrypted bytes to a temp file and handing it to the system
// share sheet (export), or opening the system file picker and reading
// back whatever the user selected (import). Both are local, OS-level
// handoffs — share_plus/file_picker never make a network call
// themselves — so this adds no INTERNET permission, same reasoning
// already applied to url_launcher's wa.me/mailto handoffs elsewhere.

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupFileService {
  const BackupFileService();

  /// Writes [bytes] to a temp file and opens the share sheet so the
  /// user picks where it actually ends up (Drive, Files, WhatsApp to
  /// themselves, etc.) — this app never assumes a destination.
  Future<void> shareBackup(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final fileName = 'noor-backup-${DateTime.now().millisecondsSinceEpoch}.noorbackup';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'noor backup'),
    );
  }

  /// Returns `null` if the user cancelled the picker.
  ///
  /// TEMPORARILY DISABLED (2026-08-27): `file_picker` 11.0.3's Kotlin
  /// module fails to compile on this project's Gradle/Kotlin config
  /// (`GeneratedPluginRegistrant.java: cannot find symbol
  /// FilePickerPlugin`) — blocked every build, and the one available
  /// upgrade (12.1.1) conflicts with `share_plus`'s `win32` constraint.
  /// Restore is stubbed to always report "cancelled" (the existing
  /// `fileBytes == null` handling in BackupRestoreScreen already
  /// treats that as a no-op) so the rest of the app can build and
  /// ship. Export (`shareBackup`, above) is untouched and still works
  /// — only restore needs `file_picker`. Re-enable once the version
  /// conflict is actually resolved, not by guessing at another bump.
  Future<Uint8List?> pickBackupFile() async {
    return null;
  }
}
