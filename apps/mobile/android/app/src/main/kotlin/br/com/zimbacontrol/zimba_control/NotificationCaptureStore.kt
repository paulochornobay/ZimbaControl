package br.com.zimbacontrol.zimba_control

import android.content.Context
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import org.json.JSONArray
import org.json.JSONObject

/** Encrypted, bounded delivery queue. This is not a financial offline DB. */
object NotificationCaptureStore {
    private const val preferencesName = "zimba_notification_capture_v2"
    private const val allowedPackagesKey = "allowed_packages"
    private const val activeAccountKey = "active_account_id"
    private const val eventsKey = "events"
    private const val maximumEvents = 100

    fun getAllowedPackages(context: Context): Set<String> = prefs(context).getStringSet(allowedPackagesKey, emptySet()).orEmpty()
    fun setAllowedPackages(context: Context, packages: Set<String>) { prefs(context).edit().putStringSet(allowedPackagesKey, packages).apply() }
    fun isPackageAllowed(context: Context, packageName: String) = getAllowedPackages(context).contains(packageName)
    fun setActiveAccount(context: Context, accountId: String) {
        val preferences = prefs(context)
        val previous = preferences.getString(activeAccountKey, null)
        // An account transition is a privacy boundary. Pending raw notification
        // content is never carried into another signed-in account.
        val editor = preferences.edit().putString(activeAccountKey, accountId)
        if (previous != null && previous != accountId) editor.remove(eventsKey)
        editor.apply()
    }
    fun clearActiveAccountAndQueue(context: Context) { prefs(context).edit().remove(activeAccountKey).remove(eventsKey).apply() }
    fun hasActiveAccount(context: Context) = !prefs(context).getString(activeAccountKey, null).isNullOrBlank()

    fun insertEvent(context: Context, event: CapturedNotificationEvent) {
        val accountId = prefs(context).getString(activeAccountKey, null) ?: return
        val events = readEvents(context)
        val stored = StoredEvent(event, accountId, "pending", 0, null)
        val index = events.indexOfFirst { it.id == event.id && it.accountId == accountId }
        if (index >= 0) events[index] = stored else events.add(stored)
        while (events.size > maximumEvents) events.removeAt(0)
        writeEvents(context, events)
    }

    fun drainPendingEvents(context: Context, limit: Int): NotificationDrain {
        val accountId = prefs(context).getString(activeAccountKey, null) ?: return NotificationDrain(emptyList(), 0, false)
        val safeLimit = limit.coerceIn(1, 100)
        val events = readEvents(context)
        val pending = events.filter { it.accountId == accountId && it.deliveryState != "delivered" }.sortedBy { it.event.capturedAt }
        val selected = pending.take(safeLimit)
        val ids = selected.map { it.id }.toSet()
        writeEvents(context, events.map { if (it.accountId == accountId && it.id in ids) it.copy(deliveryState = "delivering", attempts = it.attempts + 1, lastError = null) else it }.toMutableList())
        return NotificationDrain(selected.map { it.event.toMap() }, pending.size, pending.size > selected.size)
    }

    /** The API durably accepted these ids; no raw local content may remain. */
    fun acknowledgeDeliveredEvents(context: Context, ids: List<String>) {
        val accountId = prefs(context).getString(activeAccountKey, null) ?: return
        val acknowledged = ids.toSet()
        writeEvents(context, readEvents(context).filterNot { it.accountId == accountId && it.id in acknowledged }.toMutableList())
    }
    fun releaseEventsForRetry(context: Context, ids: List<String>, error: String?) = updateState(context, ids, "pending", error?.take(240))
    fun requestDelivery(context: Context, source: String) { /* Flutter uploads when an authenticated app is active. */ }

    fun getRecentEvents(context: Context, limit: Int): List<Map<String, Any?>> {
        val accountId = prefs(context).getString(activeAccountKey, null) ?: return emptyList()
        return readEvents(context).filter { it.accountId == accountId }.sortedByDescending { it.event.capturedAt }.take(limit.coerceIn(1, 100)).map { it.event.toMap() }
    }

    fun pruneRawEvents(context: Context, olderThanDays: Int): Int {
        val cutoff = System.currentTimeMillis() - olderThanDays.coerceAtLeast(1) * 86_400_000L
        val events = readEvents(context); val kept = events.filterNot { it.deliveryState == "delivered" && it.event.capturedAt < cutoff }
        writeEvents(context, kept.toMutableList()); return events.size - kept.size
    }

    fun resetLocalData(context: Context) { prefs(context).edit().clear().commit() }
    fun queueStatus(context: Context): Map<String, Any?> {
        val accountId = prefs(context).getString(activeAccountKey, null) ?: return mapOf("pending" to 0, "delivered" to 0)
        val events = readEvents(context).filter { it.accountId == accountId }
        return mapOf("pending" to events.count { it.deliveryState != "delivered" }, "delivered" to events.count { it.deliveryState == "delivered" })
    }

    private fun updateState(context: Context, ids: List<String>, state: String, error: String?) {
        val accountId = prefs(context).getString(activeAccountKey, null) ?: return; val idSet = ids.toSet()
        writeEvents(context, readEvents(context).map { if (it.accountId == accountId && it.id in idSet) it.copy(deliveryState = state, lastError = error) else it }.toMutableList())
    }
    private fun prefs(context: Context) = EncryptedSharedPreferences.create(context, preferencesName,
        MasterKey.Builder(context).setKeyScheme(MasterKey.KeyScheme.AES256_GCM).build(),
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM)
    private fun readEvents(context: Context): MutableList<StoredEvent> = try {
        val array = JSONArray(prefs(context).getString(eventsKey, "[]") ?: "[]")
        MutableList(array.length()) { StoredEvent.fromJson(array.getJSONObject(it)) }
    } catch (_: Exception) { mutableListOf() }
    private fun writeEvents(context: Context, events: MutableList<StoredEvent>) {
        val array = JSONArray(); events.forEach { array.put(it.toJson()) }; prefs(context).edit().putString(eventsKey, array.toString()).apply()
    }
}

data class NotificationDrain(val events: List<Map<String, Any?>>, val pendingCount: Int, val hasMore: Boolean) {
    fun toMap(): Map<String, Any?> = mapOf("events" to events, "pendingCount" to pendingCount, "hasMore" to hasMore)
}

data class CapturedNotificationEvent(val id: String, val packageName: String, val appLabel: String?, val title: String?, val text: String?, val bigText: String?, val notificationId: Int, val tag: String?, val postedAt: Long, val capturedAt: Long) {
    fun toMap(): Map<String, Any?> = mapOf("id" to id, "packageName" to packageName, "appLabel" to appLabel, "title" to title, "text" to text, "bigText" to bigText, "notificationId" to notificationId, "tag" to tag, "postedAt" to postedAt, "capturedAt" to capturedAt)
}

private data class StoredEvent(val event: CapturedNotificationEvent, val accountId: String, val deliveryState: String, val attempts: Int, val lastError: String?) {
    val id get() = event.id
    fun toJson() = JSONObject(event.toMap()).put("accountId", accountId).put("deliveryState", deliveryState).put("attempts", attempts).put("lastError", lastError)
    companion object { fun fromJson(json: JSONObject) = StoredEvent(CapturedNotificationEvent(json.getString("id"), json.getString("packageName"), json.optString("appLabel").ifEmpty { null }, json.optString("title").ifEmpty { null }, json.optString("text").ifEmpty { null }, json.optString("bigText").ifEmpty { null }, json.optInt("notificationId"), json.optString("tag").ifEmpty { null }, json.getLong("postedAt"), json.getLong("capturedAt")), json.getString("accountId"), json.optString("deliveryState", "pending"), json.optInt("attempts"), json.optString("lastError").ifEmpty { null }) }
}
