import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Message History"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "All"),
              Tab(text: "WhatsApp"),
              Tab(text: "Telegram"),
              Tab(text: "Instagram"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationList(filterApp: null),
            NotificationList(filterApp: 'com.whatsapp'),
            NotificationList(filterApp: 'org.telegram.messenger'),
            NotificationList(filterApp: 'com.instagram.android'),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  final String? filterApp;

  const NotificationList({super.key, this.filterApp});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        List<NotificationModel> notifications = provider.notifications;
        
        if (filterApp != null) {
          notifications = notifications.where((n) => n.package == filterApp).toList();
        }

        if (notifications.isEmpty) {
          return const Center(child: Text("No notifications saved yet"));
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(notification: notification);
          },
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    final date = DateTime.fromMillisecondsSinceEpoch(notification.timestamp);
    
    // Icon based on package
    IconData appIcon = Icons.notifications;
    Color appColor = Colors.grey;
    if (notification.package == 'com.whatsapp') {
      appIcon = Icons.chat; // Can't use brand icons easily without assets
      appColor = Colors.green;
    } else if (notification.package == 'org.telegram.messenger') {
      appIcon = Icons.send;
      appColor = Colors.blue;
    } else if (notification.package == 'com.instagram.android') {
      appIcon = Icons.camera_alt;
      appColor = Colors.purple;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: notification.isDeleted ? Colors.red.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: appColor,
          child: Icon(appIcon, color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.sender,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (notification.isDeleted)
              const Tooltip(
                message: "This message was deleted by sender",
                child: Icon(Icons.delete_forever, color: Colors.red, size: 20),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: notification.isDeleted ? Colors.black87 : null,
                fontStyle: notification.isDeleted ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(date),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
