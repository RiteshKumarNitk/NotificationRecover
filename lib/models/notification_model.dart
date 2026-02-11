class NotificationModel {
  final String id;
  final String package;
  final String sender;
  final String message;
  final int timestamp;
  bool isDeleted;

  NotificationModel({
    required this.id,
    required this.package,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'package': package,
      'sender': sender,
      'message': message,
      'timestamp': timestamp,
      'isDeleted': isDeleted,
    };
  }

  factory NotificationModel.fromMap(Map<dynamic, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      package: map['package'] as String,
      sender: map['sender'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as int,
      isDeleted: map['isDeleted'] as bool? ?? false,
    );
  }
}
