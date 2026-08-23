package br.com.zimbacontrol.zimba_control

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters

class NotificationReprocessWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {
    override suspend fun doWork(): Result {
        // Drift remains the financial source of truth, so this worker never
        // parses or creates transactions. It does make recovery durable: a
        // notification captured while Flutter is stopped is marked as a
        // delivery request and stays pending until Flutter acknowledges it.
        NotificationCaptureStore.requestDelivery(applicationContext, "workmanager")
        return Result.success()
    }
}
