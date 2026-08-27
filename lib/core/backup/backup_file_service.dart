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

import 'package:file_picker/file_picker.dart';
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
  Future<Uint8List?> pickBackupFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
      withData: true,
    );
    final picked = result?.files.single;
    if (picked?.bytes == null) return null;
    return picked!.bytes!;
  }
}
