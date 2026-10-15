package br.com.zimbacontrol.zimba_control

import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class NotificationCaptureStoreInstrumentedTest {
    private val context = ApplicationProvider.getApplicationContext<android.content.Context>()

    @Before
    fun setUp() {
        NotificationCaptureStore.resetLocalData(context)
        NotificationCaptureStore.setActiveAccount(context, "account-a")
    }

    @After
    fun tearDown() {
        context.deleteDatabase("zimba_notification_events.db")
    }

    @Test
    fun backlogIsPagedAndOnlyAcknowledgedEventsLeaveTheQueue() {
        NotificationCaptureStore.insertEvent(context, event("one", 1))
        NotificationCaptureStore.insertEvent(context, event("two", 2))

        val first = NotificationCaptureStore.drainPendingEvents(context, 1)

        assertEquals(1, first.events.size)
        assertTrue(first.hasMore)
        assertEquals(2, first.pendingCount)
        NotificationCaptureStore.acknowledgeDeliveredEvents(
            context,
            listOf(first.events.single().getValue("id") as String)
        )

        val second = NotificationCaptureStore.drainPendingEvents(context, 10)

        assertEquals(listOf("two"), second.events.map { it.getValue("id") })
        assertFalse(second.hasMore)
        assertEquals(1, second.pendingCount)
    }

    @Test
    fun pruningNeverRemovesAnEventThatWasNotDelivered() {
        NotificationCaptureStore.insertEvent(context, event("old", 1, capturedAt = 1))

        assertEquals(0, NotificationCaptureStore.pruneRawEvents(context, 1))
        val drain = NotificationCaptureStore.drainPendingEvents(context, 10)
        NotificationCaptureStore.acknowledgeDeliveredEvents(
            context,
            drain.events.map { it.getValue("id") as String }
        )

        // A durable API acknowledgement removes raw content immediately.
        assertEquals(0, NotificationCaptureStore.pruneRawEvents(context, 1))
        assertTrue(NotificationCaptureStore.drainPendingEvents(context, 10).events.isEmpty())
    }

    @Test
    fun switchingAccountsDiscardsThePreviousAccountsPendingRawEvents() {
        NotificationCaptureStore.insertEvent(context, event("account-a-event", 1))

        NotificationCaptureStore.setActiveAccount(context, "account-b")

        assertTrue(NotificationCaptureStore.drainPendingEvents(context, 10).events.isEmpty())
        NotificationCaptureStore.insertEvent(context, event("account-b-event", 2))
        assertEquals(
            listOf("account-b-event"),
            NotificationCaptureStore.drainPendingEvents(context, 10).events.map { it.getValue("id") },
        )
    }

    private fun event(id: String, notificationId: Int, capturedAt: Long = System.currentTimeMillis()) =
        CapturedNotificationEvent(
            id = id,
            packageName = "com.nu.production",
            appLabel = "Nubank",
            title = "Compra aprovada",
            text = "Compra aprovada de R$ 10,00",
            bigText = null,
            notificationId = notificationId,
            tag = null,
            postedAt = capturedAt,
            capturedAt = capturedAt,
        )
}
