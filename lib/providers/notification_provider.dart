// import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/notification_model.dart';
import '../services/database_service.dart';

class NotificationProvider with ChangeNotifier {
  static const platform = MethodChannel('com.notifylog.manager/notification');
  final DatabaseService _db = DatabaseService();
  final FlutterTts _flutterTts = FlutterTts();

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  List<String> _ignoreList = [];
  List<String> get ignoreList => _ignoreList;

  Box? _settingsBox;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasPermission = false;
  bool get hasPermission => _hasPermission;

  NotificationProvider() {
    _init();
  }

  Future<void> _init() async {
    await _db.init();
    _settingsBox = await Hive.openBox('settings');
    _ignoreList = _settingsBox?.get('ignoreList', defaultValue: <String>[])?.cast<String>() ?? [];
    
    platform.setMethodCallHandler(_handleMethod);
    await loadNotifications();
    await checkPermission();
    _isLoading = false;
    notifyListeners();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    if (call.method == "onNotification") {
      final Map<dynamic, dynamic> data = call.arguments;
      final map = Map<String, dynamic>.from(data);
      
      final String sender = map['title'] ?? '';
      final String package = map['package'] ?? '';
      
      // Ignore Logic
      if (_ignoreList.contains(sender) || _ignoreList.contains(package)) {
        return;
      }

      await _db.createOrUpdate(map);
      await loadNotifications();
      notifyListeners();
    }
  }

  Future<void> speakMessage(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  Future<void> toggleIgnore(String sender) async {
    if (_ignoreList.contains(sender)) {
      _ignoreList.remove(sender);
    } else {
      _ignoreList.add(sender);
    }
    await _settingsBox?.put('ignoreList', _ignoreList);
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    _notifications = _db.getAllNotifications();
    notifyListeners();
  }

  Future<void> checkPermission() async {
    try {
      final bool result = await platform.invokeMethod('checkPermission');
      _hasPermission = result;
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint("Failed to check permission: '${e.message}'.");
    }
  }

  Future<void> openSettings() async {
    try {
      await platform.invokeMethod('openSettings');
      // After returning from settings, check permission again
      // A small delay or explicit refresh button might be needed, but we'll try immediate check + lifecycle in UI
      await Future.delayed(const Duration(seconds: 1)); // Give user time to toggle
      await checkPermission();
    } on PlatformException catch (e) {
      debugPrint("Failed to open settings: '${e.message}'.");
    }
  }

  Future<void> clearHistory() async {
    await _db.clearAll();
    await loadNotifications();
  }

  Future<void> exportToFile(BuildContext context) async {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Export is not supported on Web/Test builds.")),
      );
    }
  }

  // Filter helpers
  List<NotificationModel> get whatsapp => _notifications.where((n) => n.package == 'com.whatsapp').toList();
  List<NotificationModel> get telegram => _notifications.where((n) => n.package == 'org.telegram.messenger').toList();
  List<NotificationModel> get instagram => _notifications.where((n) => n.package == 'com.instagram.android').toList();
}
