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

    fun getRecentEvents(context: Context, limit: Int): List<Map<String, Any?>> {
        val safeLimit = limit.coerceIn(1, 200)
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
                rows.add(
                    mapOf(
                        "id" to cursor.getString(0),
                        "packageName" to cursor.getString(1),
                        "appLabel" to cursor.getStringOrNull(2),
                        "title" to cursor.getStringOrNull(3),
                        "text" to cursor.getStringOrNull(4),
                        "bigText" to cursor.getStringOrNull(5),
                        "notificationId" to cursor.getIntOrNull(6),
                        "tag" to cursor.getStringOrNull(7),
                        "postedAt" to cursor.getLong(8),
                        "capturedAt" to cursor.getLong(9),
                        "rawPayloadJson" to cursor.getStringOrNull(10),
                    )
                )
            }
            return rows
        }
    }

    fun pruneRawEvents(context: Context, olderThanDays: Int): Int {
        val cutoff = System.currentTimeMillis() - olderThanDays.coerceAtLeast(1) * 86_400_000L
        return helper(context).writableDatabase.delete(
            "raw_notification_events",
            "captured_at < ?",
            arrayOf(cutoff.toString())
        )
    }

    private fun helper(context: Context): SQLiteOpenHelper {
        return NotificationDbHelper(context.applicationContext)
    }

    private class NotificationDbHelper(context: Context) :
        SQLiteOpenHelper(context, databaseName, null, 1) {
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
                    raw_payload_json TEXT
                )
                """.trimIndent()
            )
        }

        override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
            onCreate(db)
        }
    }
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
