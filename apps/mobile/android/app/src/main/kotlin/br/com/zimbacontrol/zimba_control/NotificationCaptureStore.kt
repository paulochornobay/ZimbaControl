package br.com.zimbacontrol.zimba_control

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import org.json.JSONObject

object NotificationCaptureStore {
    private const val databaseName = "zimba_notification_events.db"
    private const val preferencesName = "zimba_notification_capture"
    private const val allowedPackagesKey = "allowed_packages"

    fun getAllowedPackages(context: Context): Set<String> {
        return context
            .getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
            .getStringSet(allowedPackagesKey, emptySet())
            .orEmpty()
    }

    fun setAllowedPackages(context: Context, packages: Set<String>) {
        context
            .getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
            .edit()
            .putStringSet(allowedPackagesKey, packages)
            .apply()
    }

    fun isPackageAllowed(context: Context, packageName: String): Boolean {
        return getAllowedPackages(context).contains(packageName)
    }

    fun insertEvent(context: Context, event: CapturedNotificationEvent) {
        val values = ContentValues().apply {
            put("id", event.id)
            put("package_name", event.packageName)
            put("app_label", event.appLabel)
            put("title", event.title)
            put("body_text", event.text)
            put("big_text", event.bigText)
            put("notification_id", event.notificationId)
            put("tag", event.tag)
            put("posted_at", event.postedAt)
            put("captured_at", event.capturedAt)
            put("raw_payload_json", event.toJson().toString())
        }
        helper(context).writableDatabase.insertWithOnConflict(
            "raw_notification_events",
            null,
            values,
            SQLiteDatabase.CONFLICT_REPLACE
        )
    }

    fun drainPendingEvents(context: Context, limit: Int): NotificationDrain {
        val safeLimit = limit.coerceIn(1, 100)
        val database = helper(context).writableDatabase
        val now = System.currentTimeMillis()
        val rows = mutableListOf<Map<String, Any?>>()
        database.rawQuery(
            """
            SELECT id, package_name, app_label, title, body_text, big_text,
                   notification_id, tag, posted_at, captured_at, raw_payload_json
            FROM raw_notification_events
            WHERE delivery_state != 'delivered'
            ORDER BY captured_at ASC
            LIMIT ?
            """.trimIndent(),
            arrayOf(safeLimit.toString())
        ).use { cursor ->
            while (cursor.moveToNext()) {
                rows.add(cursor.toEventMap())
            }
        }
        if (rows.isNotEmpty()) {
            database.beginTransaction()
            try {
                for (row in rows) {
                    database.execSQL(
                        """
                        UPDATE raw_notification_events
                        SET delivery_state = 'delivering',
                            delivery_attempts = delivery_attempts + 1,
                            last_delivery_attempt_at = ?,
                            last_delivery_error = NULL
                        WHERE id = ?
                        """.trimIndent(),
                        arrayOf(now, row["id"])
                    )
                }
                database.setTransactionSuccessful()
            } finally {
                database.endTransaction()
            }
        }
        val pending = countUndelivered(database)
        putLongPreference(context, "last_drain_started_at", now)
        return NotificationDrain(rows, pending, pending > rows.size)
    }

    fun acknowledgeDeliveredEvents(context: Context, eventIds: List<String>) {
        if (eventIds.isEmpty()) return
        val database = helper(context).writableDatabase
        val now = System.currentTimeMillis()
        database.beginTransaction()
        try {
            for (eventId in eventIds.distinct()) {
                database.execSQL(
                    """
                    UPDATE raw_notification_events
                    SET delivery_state = 'delivered', delivered_at = ?, last_delivery_error = NULL
                    WHERE id = ?
                    """.trimIndent(),
                    arrayOf(now, eventId)
                )
            }
            database.setTransactionSuccessful()
        } finally {
            database.endTransaction()
        }
        putLongPreference(context, "last_drain_completed_at", now)
    }

    fun releaseEventsForRetry(context: Context, eventIds: List<String>, error: String?) {
        if (eventIds.isEmpty()) return
        val database = helper(context).writableDatabase
        database.beginTransaction()
        try {
            for (eventId in eventIds.distinct()) {
                database.execSQL(
                    """
                    UPDATE raw_notification_events
                    SET delivery_state = 'pending', last_delivery_error = ?
                    WHERE id = ? AND delivery_state != 'delivered'
                    """.trimIndent(),
                    arrayOf(error?.take(240), eventId)
                )
            }
            database.setTransactionSuccessful()
        } finally {
            database.endTransaction()
        }
    }

    fun requestDelivery(context: Context, source: String) {
        val now = System.currentTimeMillis()
        putLongPreference(context, "last_delivery_request_at", now)
        context.getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
            .edit()
            .putString("last_delivery_request_source", source)
            .putInt("pending_at_last_delivery_request", countUndelivered(helper(context).readableDatabase))
            .apply()
    }

    fun getRecentEvents(context: Context, limit: Int): List<Map<String, Any?>> {
        val safeLimit = limit.coerceIn(1, 100)
        helper(context).readableDatabase.rawQuery(
            """
            SELECT id, package_name, app_label, title, body_text, big_text,
                   notification_id, tag, posted_at, captured_at, raw_payload_json
            FROM raw_notification_events
            ORDER BY captured_at DESC
            LIMIT ?
            """.trimIndent(),
            arrayOf(safeLimit.toString())
        ).use { cursor ->
            val rows = mutableListOf<Map<String, Any?>>()
            while (cursor.moveToNext()) {
                rows.add(cursor.toEventMap())
            }
            return rows
        }
    }

    fun pruneRawEvents(context: Context, olderThanDays: Int): Int {
        val cutoff = System.currentTimeMillis() - olderThanDays.coerceAtLeast(1) * 86_400_000L
        return helper(context).writableDatabase.delete(
            "raw_notification_events",
            "captured_at < ? AND delivery_state = 'delivered'",
            arrayOf(cutoff.toString())
        )
    }

    fun queueStatus(context: Context): Map<String, Any?> {
        val database = helper(context).readableDatabase
        val preferences = context.getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
        return mapOf(
            "pending" to countUndelivered(database),
            "delivered" to countByState(database, "delivered"),
            "lastDrainStartedAt" to preferences.getLong("last_drain_started_at", 0),
            "lastDrainCompletedAt" to preferences.getLong("last_drain_completed_at", 0),
            "lastDeliveryRequestAt" to preferences.getLong("last_delivery_request_at", 0),
            "lastDeliveryRequestSource" to preferences.getString("last_delivery_request_source", null),
        )
    }

    private fun countUndelivered(database: SQLiteDatabase): Int =
        database.rawQuery(
            "SELECT COUNT(*) FROM raw_notification_events WHERE delivery_state != 'delivered'",
            null
        ).use { cursor -> cursor.moveToFirst(); cursor.getInt(0) }

    private fun countByState(database: SQLiteDatabase, state: String): Int =
        database.rawQuery(
            "SELECT COUNT(*) FROM raw_notification_events WHERE delivery_state = ?",
            arrayOf(state)
        ).use { cursor -> cursor.moveToFirst(); cursor.getInt(0) }

    private fun putLongPreference(context: Context, key: String, value: Long) {
        context.getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
            .edit()
            .putLong(key, value)
            .apply()
    }

    private fun helper(context: Context): SQLiteOpenHelper {
        return NotificationDbHelper(context.applicationContext)
    }

    private class NotificationDbHelper(context: Context) :
        SQLiteOpenHelper(context, databaseName, null, 2) {
        override fun onCreate(db: SQLiteDatabase) {
            db.execSQL(
                """
                CREATE TABLE IF NOT EXISTS raw_notification_events (
                    id TEXT PRIMARY KEY NOT NULL,
                    package_name TEXT NOT NULL,
                    app_label TEXT,
                    title TEXT,
                    body_text TEXT,
                    big_text TEXT,
                    notification_id INTEGER,
                    tag TEXT,
                    posted_at INTEGER NOT NULL,
                    captured_at INTEGER NOT NULL,
                    raw_payload_json TEXT,
                    delivery_state TEXT NOT NULL DEFAULT 'pending',
                    delivery_attempts INTEGER NOT NULL DEFAULT 0,
                    last_delivery_attempt_at INTEGER,
                    delivered_at INTEGER,
                    last_delivery_error TEXT
                )
                """.trimIndent()
            )
        }

        override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
            if (oldVersion < 2) {
                db.execSQL("ALTER TABLE raw_notification_events ADD COLUMN delivery_state TEXT NOT NULL DEFAULT 'pending'")
                db.execSQL("ALTER TABLE raw_notification_events ADD COLUMN delivery_attempts INTEGER NOT NULL DEFAULT 0")
                db.execSQL("ALTER TABLE raw_notification_events ADD COLUMN last_delivery_attempt_at INTEGER")
                db.execSQL("ALTER TABLE raw_notification_events ADD COLUMN delivered_at INTEGER")
                db.execSQL("ALTER TABLE raw_notification_events ADD COLUMN last_delivery_error TEXT")
            }
        }
    }
}

data class NotificationDrain(
    val events: List<Map<String, Any?>>,
    val pendingCount: Int,
    val hasMore: Boolean,
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "events" to events,
        "pendingCount" to pendingCount,
        "hasMore" to hasMore,
    )
}

data class CapturedNotificationEvent(
    val id: String,
    val packageName: String,
    val appLabel: String?,
    val title: String?,
    val text: String?,
    val bigText: String?,
    val notificationId: Int,
    val tag: String?,
    val postedAt: Long,
    val capturedAt: Long,
) {
    fun toJson(): JSONObject {
        return JSONObject()
            .put("id", id)
            .put("packageName", packageName)
            .put("appLabel", appLabel)
            .put("title", title)
            .put("text", text)
            .put("bigText", bigText)
            .put("notificationId", notificationId)
            .put("tag", tag)
            .put("postedAt", postedAt)
            .put("capturedAt", capturedAt)
    }
}

private fun android.database.Cursor.getStringOrNull(index: Int): String? {
    return if (isNull(index)) null else getString(index)
}

private fun android.database.Cursor.getIntOrNull(index: Int): Int? {
    return if (isNull(index)) null else getInt(index)
}

private fun android.database.Cursor.toEventMap(): Map<String, Any?> = mapOf(
    "id" to getString(0),
    "packageName" to getString(1),
    "appLabel" to getStringOrNull(2),
    "title" to getStringOrNull(3),
    "text" to getStringOrNull(4),
    "bigText" to getStringOrNull(5),
    "notificationId" to getIntOrNull(6),
    "tag" to getStringOrNull(7),
    "postedAt" to getLong(8),
    "capturedAt" to getLong(9),
    "rawPayloadJson" to getStringOrNull(10),
)
