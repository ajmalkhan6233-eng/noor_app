// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Fires at a scheduled time (set from Dart via MainActivity's
// AlarmManager calls) to silence or restore the ringer for Silent
// Mode. No network, no background service — a single one-shot
// broadcast per alarm.
//
// NOTE: this cannot be exercised on a device/emulator in this
// environment; written to standard AudioManager/BroadcastReceiver
// conventions but not runtime-verified.

package com.noorapp.noor

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioManager

class SilentModeReceiver : BroadcastReceiver() {
    companion object {
        const val EXTRA_ACTION = "action"
        const val ACTION_SILENCE = "SILENCE"
        const val ACTION_RESTORE = "RESTORE"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val audioManager =
            context.getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return
        when (intent.getStringExtra(EXTRA_ACTION)) {
            ACTION_SILENCE -> audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
            ACTION_RESTORE -> audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
        }
    }
}
