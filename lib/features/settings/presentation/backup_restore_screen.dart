// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Local encrypted backup/export (2026-08-27, direct request: "the
// real safety net for an app with no cloud backup — losing a phone
// shouldn't mean losing everything"). Everything stays on-device or
// wherever the user's own share-sheet choice sends it — this screen
// makes no network call itself. See core/backup/ for the actual
// gather/encrypt/restore logic; this file is presentation only.

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/backup/backup_crypto.dart';
import '../../../core/backup/backup_file_service.dart';
import '../../../core/backup/backup_payload.dart';
import '../../../core/backup/backup_repository.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/semantics_helpers.dart';
import 'widgets/backup_passphrase_dialog.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final _repository = BackupRepository();
  final _fileService = const BackupFileService();
  bool _busy = false;

  Future<void> _export() async {
    final passphrase = await promptForPassphrase(context, confirmationRequired: true);
    if (passphrase == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final payload = await _repository.gather();
      final plaintext = utf8.encode(jsonEncode(payload.toJson()));
      final encrypted = await encryptBackup(passphrase: passphrase, plaintext: plaintext);
      await _fileService.shareBackup(encrypted);
      _showMessage('Backup ready — choose where to save it.');
    } catch (e) {
      _showMessage("Couldn't create the backup: $e");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final fileBytes = await _fileService.pickBackupFile();
    if (fileBytes == null || !mounted) return;
    final passphrase = await promptForPassphrase(context, confirmationRequired: false);
    if (passphrase == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final plaintext = await decryptBackup(passphrase: passphrase, fileBytes: fileBytes);
      final payload = BackupPayload.fromJson(jsonDecode(utf8.decode(plaintext)) as Map<String, dynamic>);
      final result = await _repository.restore(payload);
      final skippedNote =
          result.azkarBookmarksSkipped > 0 ? ' (${result.azkarBookmarksSkipped} Azkar bookmarks skipped — dataset changed since that backup)' : '';
      _showMessage('Backup restored.$skippedNote');
    } on BackupDecryptException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      _showMessage("Couldn't restore that backup: $e");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        title: const Text('Backup & Restore', style: TextStyle(color: AppColors.ink)),
        iconTheme: const IconThemeData(color: AppColors.gold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Save your prayer/fasting streak history, Quran and Azkar '
              "bookmarks, and Zakat calculator memory to a passphrase-"
              "encrypted file you keep yourself — noor has no cloud "
              'account, so this is the only way to carry it to a new '
              'phone or recover it if this one is lost.',
              style: TextStyle(color: AppColors.sage, height: 1.4),
            ),
            const SizedBox(height: 24),
            _ActionButton(
              icon: Icons.upload_outlined,
              label: 'Export a backup',
              busy: _busy,
              onTap: _export,
            ),
            const SizedBox(height: 12),
            _ActionButton(
              icon: Icons.download_outlined,
              label: 'Restore from a backup',
              busy: _busy,
              onTap: _import,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.busy,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SemanticButton(
        label: label,
        onTap: busy ? () {} : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.paper),
                )
              else
                Icon(icon, color: AppColors.paper, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppColors.paper, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
