package com.notifylog.manager

import android.app.Notification
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class MyNotificationListenerService : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        
        // Filter for specific apps
        if (packageName == "com.whatsapp" || 
            packageName == "org.telegram.messenger" || 
            packageName == "com.instagram.android") {
            
            val extras = sbn.notification.extras
            val title = extras.getString(Notification.EXTRA_TITLE) ?: "Unknown"
            val text = extras.getString(Notification.EXTRA_TEXT) ?: ""
            
            // Ignore ongoing or irrelevant notifications (simple filter)
            if (text.isEmpty() || text == "Checking for new messages") return

            Log.d("NotificationListener", "Notification from $packageName: $title - $text")

            // Send Broadcast to MainActivity
            val intent = Intent("com.notifylog.manager.NOTIFICATION_LISTENER")
            intent.putExtra("package", packageName)
            intent.putExtra("title", title)
            intent.putExtra("text", text)
            intent.putExtra("time", sbn.postTime)
            sendBroadcast(intent)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        // Handle removal if needed (e.g., to detect if user dismissed it vs sender deleted it)
        // But sender deleting it doesn't remove the notification automatically on all apps instantly,
        // or rather, we want to capturing the *content* when it arrives.
    }
}
