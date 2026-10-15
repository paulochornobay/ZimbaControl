package br.com.zimbacontrol.zimba_control

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters

class NotificationReprocessWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {
    override suspend fun doWork(): Result {
        // MongoDB, through the authenticated API, is the financial source of
        // truth. This worker never parses or creates a transaction; it only
        // requests delivery of the bounded encrypted notification queue.
        NotificationCaptureStore.requestDelivery(applicationContext, "workmanager")
        return Result.success()
    }
}
