package br.com.zimbacontrol.zimba_control

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters

class NotificationReprocessWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {
    override suspend fun doWork(): Result {
        // Flutter/Drift owns canonical parsing. This worker exists so captured
        // events can be retried or reprocessed later without changing the
        // notification listener contract.
        NotificationCaptureStore.getRecentEvents(applicationContext, 1)
        return Result.success()
    }
}
