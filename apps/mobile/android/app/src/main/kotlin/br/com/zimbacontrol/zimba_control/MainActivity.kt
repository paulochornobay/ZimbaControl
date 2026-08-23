package br.com.zimbacontrol.zimba_control

import android.content.ComponentName
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "br.com.zimbacontrol/notifications"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getStatus" -> {
                    result.success(
                        mapOf(
                            "available" to true,
                            "permissionGranted" to isNotificationListenerEnabled(),
                            "allowedPackages" to NotificationCaptureStore.getAllowedPackages(this).toList(),
                            "recentEvents" to NotificationCaptureStore.getRecentEvents(this, 10),
                            "queue" to NotificationCaptureStore.queueStatus(this),
                        )
                    )
                }
                "openNotificationSettings" -> {
                    startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                    result.success(null)
                }
                "setAllowedPackages" -> {
                    val packages = call.argument<List<String>>("packages").orEmpty()
                    NotificationCaptureStore.setAllowedPackages(this, packages.toSet())
                    result.success(NotificationCaptureStore.getAllowedPackages(this).toList())
                }
                "getRecentEvents" -> {
                    val limit = call.argument<Int>("limit") ?: 50
                    result.success(NotificationCaptureStore.getRecentEvents(this, limit))
                }
                "drainPendingEvents" -> {
                    val limit = call.argument<Int>("limit") ?: 50
                    result.success(NotificationCaptureStore.drainPendingEvents(this, limit).toMap())
                }
                "acknowledgeDeliveredEvents" -> {
                    val eventIds = call.argument<List<String>>("eventIds").orEmpty()
                    NotificationCaptureStore.acknowledgeDeliveredEvents(this, eventIds)
                    result.success(null)
                }
                "releaseEventsForRetry" -> {
                    val eventIds = call.argument<List<String>>("eventIds").orEmpty()
                    val error = call.argument<String>("error")
                    NotificationCaptureStore.releaseEventsForRetry(this, eventIds, error)
                    result.success(null)
                }
                "pruneRawEvents" -> {
                    val olderThanDays = call.argument<Int>("olderThanDays") ?: 30
                    result.success(NotificationCaptureStore.pruneRawEvents(this, olderThanDays))
                }
                "resetLocalCapture" -> {
                    NotificationCaptureStore.resetLocalData(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isNotificationListenerEnabled(): Boolean {
        val enabled = Settings.Secure.getString(
            contentResolver,
            "enabled_notification_listeners"
        ) ?: return false
        val expected = ComponentName(
            this,
            ZimbaNotificationListenerService::class.java
        ).flattenToString()
        return enabled.split(":").any { it.equals(expected, ignoreCase = true) }
    }
}
