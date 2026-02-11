import 'package:hive_flutter/hive_flutter.dart';
import '../models/notification_model.dart';

class DatabaseService {
  static const String boxName = 'notifications';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  Box get _box => Hive.box(boxName);

  Future<void> saveNotification(NotificationModel notification) async {
    await _box.put(notification.id, notification.toMap());
  }

  List<NotificationModel> getAllNotifications() {
    final rawList = _box.values.toList();
    final notifications = rawList.map((e) => NotificationModel.fromMap(e as Map)).toList();
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
    return notifications;
  }

  Future<void> createOrUpdate(Map<String, dynamic> data) async {
    final String package = data['package'];
    final String title = data['title']; // sender
    final String text = data['text']; // message
    final int time = data['time'];
    
    // Simple deduplication check: if same message from same sender within 1 second, ignore
    // Or just use time + sender as ID? No, ID should be unique.
    final id = "${time}_$package";

    if (text.contains("This message was deleted")) {
       await _markAsDeleted(title, package);
    } else {
       final notification = NotificationModel(
         id: id,
         package: package,
         sender: title,
         message: text,
         timestamp: time,
       );
       await saveNotification(notification);
    }
  }

  Future<void> _markAsDeleted(String sender, String package) async {
    final notifications = getAllNotifications();
    // Find the most recent message from this sender in this package that isn't already deleted
    try {
      final lastMsg = notifications.firstWhere((n) => 
        n.package == package && 
        n.sender == sender && 
        !n.isDeleted && 
        !n.message.contains("This message was deleted")
      );
      
      lastMsg.isDeleted = true;
      await _box.put(lastMsg.id, lastMsg.toMap());
    } catch (e) {
      // No matching message found
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
