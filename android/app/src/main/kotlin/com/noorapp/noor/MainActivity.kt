// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Exposes a single MethodChannel ("com.noorapp.noor/silent_mode") for
// Silent Mode: checking/requesting Do-Not-Disturb access, and
// scheduling/cancelling the two AlarmManager alarms (silence, then
// restore) that bracket a prayer's adhan-to-iqamath window. All state
// change is local to the device — no network involved.
//
// NOTE: this cannot be exercised on a device/emulator in this
// environment; written to standard AlarmManager/NotificationManager
// conventions but not runtime-verified.

package com.noorapp.noor

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.noorapp.noor/silent_mode"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasNotificationPolicyAccess" ->
                        result.success(hasNotificationPolicyAccess())
                    "requestNotificationPolicyAccess" -> {
                        requestNotificationPolicyAccess()
                        result.success(null)
                    }
                    "scheduleSilentWindow" -> {
                        scheduleSilentWindow(
                            call.argument<Long>("startEpochMillis")!!,
                            call.argument<Long>("endEpochMillis")!!,
                            call.argument<Int>("requestCode")!!,
                        )
                        result.success(null)
                    }
                    "cancelSilentWindow" -> {
                        cancelSilentWindow(call.argument<Int>("requestCode")!!)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasNotificationPolicyAccess(): Boolean {
        val manager = getSystemService(NotificationManager::class.java) ?: return false
        return manager.isNotificationPolicyAccessGranted
    }

    private fun requestNotificationPolicyAccess() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun scheduleSilentWindow(startEpochMillis: Long, endEpochMillis: Long, requestCode: Int) {
        val alarmManager = getSystemService(AlarmManager::class.java) ?: return
        setAlarm(alarmManager, startEpochMillis, requestCode, SilentModeReceiver.ACTION_SILENCE)
        setAlarm(alarmManager, endEpochMillis, requestCode + 1, SilentModeReceiver.ACTION_RESTORE)
    }

    private fun setAlarm(alarmManager: AlarmManager, triggerAtMillis: Long, requestCode: Int, action: String) {
        val intent = Intent(this, SilentModeReceiver::class.java)
        intent.putExtra(SilentModeReceiver.EXTRA_ACTION, action)
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val pendingIntent = PendingIntent.getBroadcast(this, requestCode, intent, flags)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
            alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
        } else {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
        }
    }

    private fun cancelSilentWindow(requestCode: Int) {
        val alarmManager = getSystemService(AlarmManager::class.java) ?: return
        cancelAlarm(alarmManager, requestCode)
        cancelAlarm(alarmManager, requestCode + 1)
    }

    private fun cancelAlarm(alarmManager: AlarmManager, requestCode: Int) {
        val intent = Intent(this, SilentModeReceiver::class.java)
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val pendingIntent = PendingIntent.getBroadcast(this, requestCode, intent, flags)
        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()
    }
}
