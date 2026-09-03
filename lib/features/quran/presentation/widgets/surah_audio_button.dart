// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reusable play/pause control for one surah's recitation — shared by
// SurahReaderScreen (in its AppBar) and FullQuranScreen (per surah
// section). For a bundled surah this is a plain play/pause icon, same
// as always. For anything else, it now offers an on-demand download
// (2026-09-03) instead of just reporting "unavailable" — see
// surah_audio_download_service.dart for the scoping decision. Real
// progress while downloading, a clear error on failure (never fails
// silently), and switches to a normal play button once the file is
// saved locally.

import 'package:flutter/material.dart';

import '../../data/surah_audio_download_service.dart';
import '../../data/surah_audio_player.dart';
import 'audio_download_disclosure.dart';
import '../../../../core/constants/app_color_tokens.dart';

enum _AudioAvailability { checking, bundledOrDownloaded, downloadable }

class SurahAudioButton extends StatefulWidget {
  const SurahAudioButton({
    super.key,
    required this.surahId,
    required this.isPlaying,
    required this.onToggle,
    this.downloadService = const SurahAudioDownloadService(),
  });

  final int surahId;
  final bool isPlaying;
  final VoidCallback onToggle;
  final SurahAudioDownloadService downloadService;

  @override
  State<SurahAudioButton> createState() => _SurahAudioButtonState();
}

class _SurahAudioButtonState extends State<SurahAudioButton> {
  _AudioAvailability _availability = _AudioAvailability.checking;
  double? _downloadProgress;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  @override
  void didUpdateWidget(SurahAudioButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahId != widget.surahId) _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    if (hasBundledSurahAudio(widget.surahId)) {
      setState(() => _availability = _AudioAvailability.bundledOrDownloaded);
      return;
    }
    final downloaded = await widget.downloadService.isDownloaded(widget.surahId);
    if (!mounted) return;
    setState(() {
      _availability = downloaded
          ? _AudioAvailability.bundledOrDownloaded
          : _AudioAvailability.downloadable;
    });
  }

  Future<void> _startDownload() async {
    await maybeShowAudioDownloadDisclosure(context);
    if (!mounted) return;
    setState(() {
      _downloadProgress = 0;
      _error = null;
    });
    try {
      await for (final progress in widget.downloadService.download(widget.surahId)) {
        if (!mounted) return;
        setState(() => _downloadProgress = progress.fraction ?? _downloadProgress);
      }
      if (!mounted) return;
      setState(() {
        _downloadProgress = null;
        _availability = _AudioAvailability.bundledOrDownloaded;
      });
    } on SurahDownloadFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _downloadProgress = null;
        _error = e.message;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      const message = 'Download failed. Please try again.';
      setState(() {
        _downloadProgress = null;
        _error = message;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_downloadProgress != null) {
      return Semantics(
        label: 'Downloading recitation',
        value: '${((_downloadProgress ?? 0) * 100).round()} percent',
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: _downloadProgress! > 0 ? _downloadProgress : null,
            color: context.colors.gold,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (_availability == _AudioAvailability.downloadable) {
      return Semantics(
        button: true,
        label: _error == null ? 'Download recitation' : 'Download failed, tap to retry',
        hint: 'Double tap to download this surah\'s recitation for offline playback',
        child: IconButton(
          icon: Icon(_error == null ? Icons.download_outlined : Icons.error_outline),
          color: _error == null ? context.colors.gold : Colors.redAccent,
          tooltip: 'Download recitation',
          onPressed: _startDownload,
        ),
      );
    }

    final available = _availability == _AudioAvailability.bundledOrDownloaded;
    return Semantics(
      button: true,
      label: available
          ? (widget.isPlaying ? 'Pause recitation' : 'Play recitation')
          : 'Recitation unavailable for this Surah',
      value: widget.isPlaying ? 'Playing' : 'Stopped',
      hint: available ? 'Double tap to control recitation' : 'Checking availability',
      child: IconButton(
        icon: Icon(widget.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline),
        color: available ? context.colors.gold : context.colors.sage,
        tooltip: available
            ? (widget.isPlaying ? 'Pause recitation' : 'Play recitation')
            : 'Recitation unavailable for this Surah',
        onPressed: available ? widget.onToggle : null,
      ),
    );
  }
}
