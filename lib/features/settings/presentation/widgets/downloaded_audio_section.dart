// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Storage management for on-demand-downloaded Quran audio
// (surah_audio_download_service.dart) — how much space it's using,
// with a way to delete it and free that space back up. Bundled audio
// (Juz Amma/curated surahs) is untouched by this; only what this
// feature itself downloaded.

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../quran/data/surah_audio_download_service.dart';
import '../../../../core/constants/app_color_tokens.dart';

class DownloadedAudioSection extends StatefulWidget {
  const DownloadedAudioSection({
    super.key,
    this.downloadService = const SurahAudioDownloadService(),
  });

  final SurahAudioDownloadService downloadService;

  @override
  State<DownloadedAudioSection> createState() => _DownloadedAudioSectionState();
}

class _DownloadedAudioSectionState extends State<DownloadedAudioSection> {
  int? _bytesUsed;
  int? _count;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final bytes = await widget.downloadService.totalBytesUsed();
    final count = await widget.downloadService.downloadedCount();
    if (mounted) {
      setState(() {
        _bytesUsed = bytes;
        _count = count;
      });
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    // Nothing has ever been downloaded — nothing to show or manage.
    if (_count == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Downloaded Audio'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _count == null
                    ? 'Checking...'
                    : '$_count downloaded surah${_count == 1 ? '' : 's'} — '
                          '${_formatSize(_bytesUsed ?? 0)} of storage',
                style: TextStyle(color: context.colors.sage),
              ),
              const SizedBox(height: 8),
              if (_count != null && _count! > 0)
                SemanticButton(
                  label: 'Delete downloaded audio',
                  hint: 'Frees the storage used by downloaded surah recitations — bundled audio is unaffected',
                  onTap: () async {
                    if (_deleting) return;
                    setState(() => _deleting = true);
                    await widget.downloadService.deleteAll();
                    await _refresh();
                    if (mounted) setState(() => _deleting = false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      _deleting ? 'Deleting...' : 'Delete downloaded audio',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.colors.gold),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
