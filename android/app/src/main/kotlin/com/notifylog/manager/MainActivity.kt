package com.notifylog.manager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.notifylog.manager/notification"
    private var methodChannel: MethodChannel? = null

    private val notificationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == "com.whatsappRecover.whatsapp_recover.NOTIFICATION_LISTENER") {
                val packageName = intent.getStringExtra("package")
                val title = intent.getStringExtra("title")
                val text = intent.getStringExtra("text")
                val time = intent.getLongExtra("time", 0)

                val data = mapOf(
                    "package" to packageName,
                    "title" to title,
                    "text" to text,
                    "time" to time
                )
                
                methodChannel?.invokeMethod("onNotification", data)
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission" -> {
                    val hasPermission = Settings.Secure.getString(contentResolver, "enabled_notification_listeners").contains(packageName)
                    result.success(hasPermission)
                }
                "openSettings" -> {
                    startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        val filter = IntentFilter("com.notifylog.manager.NOTIFICATION_LISTENER")
        if (Build.VERSION.SDK_INT >= 33) {
            registerReceiver(notificationReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(notificationReceiver, filter)
        }
    }

    override fun onDestroy() {
        unregisterReceiver(notificationReceiver)
        super.onDestroy()
    }
}
