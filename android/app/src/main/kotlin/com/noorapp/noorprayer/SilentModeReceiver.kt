// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Silent Mode window: SILENCE at the adhan, RESTORE after iqamath.
// Safety rules (2026-11-19 audit):
// - The ringer mode saved before a window is never overwritten by a
//   second SILENCE (overlapping windows used to save SILENT as the
//   "previous" mode, leaving the phone silent for good).
// - RESTORE only acts if a window is active, and only if the phone is
//   still silent (if the person changed it themselves, leave it).
// - After a reboot the RESTORE alarm is gone (AlarmManager clears on
//   boot), so BOOT_COMPLETED restores the saved mode straight away.
// - Losing Do Not Disturb access makes ringerMode throw
//   SecurityException; that is caught instead of crashing.

package com.noorapp.noorprayer

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioManager

class SilentModeReceiver : BroadcastReceiver() {
    companion object {
        const val EXTRA_ACTION = "action"
        const val ACTION_SILENCE = "SILENCE"
        const val ACTION_RESTORE = "RESTORE"
        private const val PREFS_NAME = "silent_mode_prefs"
        private const val KEY_PREVIOUS_RINGER_MODE = "previous_ringer_mode"
        private const val KEY_WINDOW_ACTIVE = "window_active"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val audioManager =
            context.getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val active = prefs.getBoolean(KEY_WINDOW_ACTIVE, false)
        val action = if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            ACTION_RESTORE
        } else {
            intent.getStringExtra(EXTRA_ACTION)
        }
        try {
            when (action) {
                ACTION_SILENCE -> {
                    if (!active) {
                        prefs.edit()
                            .putInt(KEY_PREVIOUS_RINGER_MODE, audioManager.ringerMode)
                            .putBoolean(KEY_WINDOW_ACTIVE, true)
                            .apply()
                    }
                    audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                }
                ACTION_RESTORE -> {
                    if (!active) return
                    prefs.edit().putBoolean(KEY_WINDOW_ACTIVE, false).apply()
                    if (audioManager.ringerMode != AudioManager.RINGER_MODE_SILENT) return
                    audioManager.ringerMode = prefs.getInt(
                        KEY_PREVIOUS_RINGER_MODE,
                        AudioManager.RINGER_MODE_NORMAL,
                    )
                }
            }
        } catch (_: SecurityException) {
            // Do Not Disturb access was revoked; nothing safe to do.
        }
    }
}
