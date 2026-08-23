package br.com.zimbacontrol.zimba_control

import android.app.Notification
import android.os.Build
import android.content.pm.PackageManager
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.Executors

class ZimbaNotificationListenerService : NotificationListenerService() {
    private val executor = Executors.newSingleThreadExecutor()

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        if (!NotificationCaptureStore.isPackageAllowed(this, sbn.packageName)) {
            return
        }

        val extras = sbn.notification.extras
        val event = CapturedNotificationEvent(
            id = sbn.key,
            packageName = sbn.packageName,
            appLabel = appLabelFor(sbn.packageName),
            title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString(),
            text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString(),
            bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString(),
            notificationId = sbn.id,
            tag = sbn.tag,
            postedAt = sbn.postTime,
            capturedAt = System.currentTimeMillis(),
        )

        executor.execute {
            NotificationCaptureStore.insertEvent(this, event)
            NotificationCaptureStore.requestDelivery(this, "listener")
            enqueueReprocess()
        }
    }

    override fun onDestroy() {
        executor.shutdown()
        super.onDestroy()
    }

    private fun appLabelFor(packageName: String): String? {
        return try {
            val applicationInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                packageManager.getApplicationInfo(
                    packageName,
                    PackageManager.ApplicationInfoFlags.of(0)
                )
            } else {
                @Suppress("DEPRECATION")
                packageManager.getApplicationInfo(packageName, 0)
            }
            packageManager.getApplicationLabel(applicationInfo).toString()
        } catch (_: Exception) {
            null
        }
    }

    private fun enqueueReprocess() {
        val request = OneTimeWorkRequestBuilder<NotificationReprocessWorker>()
            .addTag("notification-capture")
            .build()
        WorkManager.getInstance(this).enqueueUniqueWork(
            "zimba-notification-reprocess",
            ExistingWorkPolicy.APPEND_OR_REPLACE,
            request
        )
    }
}
