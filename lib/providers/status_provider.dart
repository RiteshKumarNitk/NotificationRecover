// import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class StatusProvider with ChangeNotifier {
  List<dynamic> _statuses = [];
  List<dynamic> get statuses => _statuses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPermissionGranted = false;
  bool get isPermissionGranted => _isPermissionGranted;

  static const String whatsappPath = '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
  static const String whatsappPathLegacy = '/storage/emulated/0/WhatsApp/Media/.Statuses';

  Future<void> getStatuses() async {
    _isLoading = true;
    notifyListeners();
    
    if (kIsWeb) {
       _isLoading = false;
       notifyListeners();
       return;
    }

    /*
    // Check permission
    if (await Permission.storage.request().isGranted || 
        await Permission.manageExternalStorage.request().isGranted) {
      _isPermissionGranted = true;
      
      final directory = Directory(whatsappPath);
      final directoryLegacy = Directory(whatsappPathLegacy);
      
      try {
        if (directory.existsSync()) {
          _statuses = directory.listSync().where((element) => 
            element.path.endsWith('.jpg') || 
            element.path.endsWith('.mp4')).toList();
        } else if (directoryLegacy.existsSync()) {
          _statuses = directoryLegacy.listSync().where((element) => 
            element.path.endsWith('.jpg') || 
            element.path.endsWith('.mp4')).toList();
        } else {
           debugPrint("Status folder not found.");
        }
      } catch (e) {
        debugPrint("Error loading statuses: $e");
      }
    } else {
      _isPermissionGranted = false;
    }
    */
    _isLoading = false;
    notifyListeners();
  }
}
