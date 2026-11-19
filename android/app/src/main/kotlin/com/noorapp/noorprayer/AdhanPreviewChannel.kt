// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Settings/Prayer "preview adhan" playback straight from res/raw — the
// same files the adhan notifications use. Until 2026-11-19 every adhan
// was also bundled a second time under assets/audio/adhan just for the
// preview (about 20 MB twice). R.raw references here also keep the
// files through release resource shrinking.

package com.noorapp.noorprayer

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class AdhanPreviewChannel(private val context: Context, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "com.noorapp.noorprayer/adhan_preview")
    private var player: MediaPlayer? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "play" -> result.success(play(call.argument<String>("name")))
                "stop" -> {
                    stop()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun resourceFor(name: String?): Int? = when (name) {
        "adhan_fajr" -> R.raw.adhan_fajr
        "adhan_dhuhr" -> R.raw.adhan_dhuhr
        "adhan_asr" -> R.raw.adhan_asr
        "adhan_maghrib" -> R.raw.adhan_maghrib
        "adhan_isha" -> R.raw.adhan_isha
        "adhan_indonesia" -> R.raw.adhan_indonesia
        "adhan_marrakech" -> R.raw.adhan_marrakech
        "adhan_aroumd" -> R.raw.adhan_aroumd
        "adhan_hamtramck" -> R.raw.adhan_hamtramck
        else -> null
    }

    private fun play(name: String?): Boolean {
        val resId = resourceFor(name) ?: return false
        stop()
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_MEDIA)
            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
            .build()
        val created = MediaPlayer.create(context, resId, attributes, 0) ?: return false
        created.setOnCompletionListener {
            stop()
            channel.invokeMethod("completed", null)
        }
        created.start()
        player = created
        return true
    }

    fun stop() {
        player?.let {
            try {
                if (it.isPlaying) it.stop()
            } catch (e: IllegalStateException) {
                // Already stopped/released.
            }
            it.release()
        }
        player = null
    }
}
