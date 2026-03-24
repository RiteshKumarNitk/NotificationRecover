import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class StatusProvider with ChangeNotifier {
  List<File> _statuses = [];
  List<File> get statuses => _statuses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPermissionGranted = false;
  bool get isPermissionGranted => _isPermissionGranted;

  /// WhatsApp Status folder path (Android 11+)
  static const String _statusPath =
      "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";

  Future<void> getStatuses() async {
    _isLoading = true;
    notifyListeners();

    if (kIsWeb) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      /// 🔐 Request permissions
      final storage = await Permission.storage.request();
      final manage = await Permission.manageExternalStorage.request();

      if (!storage.isGranted && !manage.isGranted) {
        _isPermissionGranted = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      _isPermissionGranted = true;

      /// 📂 Access WhatsApp status folder
      final directory = Directory(_statusPath);

      if (directory.existsSync()) {
        final files = directory.listSync();

        _statuses = files
            .whereType<File>()
            .where((file) {
              final path = file.path.toLowerCase();
              return path.endsWith('.jpg') ||
                     path.endsWith('.jpeg') ||
                     path.endsWith('.png') ||
                     path.endsWith('.mp4');
            })
            .toList();

        /// Sort latest first
        _statuses.sort(
          (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
        );
      } else {
        _statuses = [];
      }
    } catch (e) {
      debugPrint("Error loading statuses: $e");
      _isPermissionGranted = false;
    }

    _isLoading = false;
    notifyListeners();
  }
}