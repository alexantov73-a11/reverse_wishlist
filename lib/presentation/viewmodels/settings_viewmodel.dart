import 'package:flutter/foundation.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/notification_service.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  bool _notificationsEnabled = true;

  SettingsViewModel(this._storageService);

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadSettings() async {
    _notificationsEnabled = true;
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      // Коли включаємо - просимо дозвіл на iOS
      final granted = await NotificationService().requestIOSPermissions();
      _notificationsEnabled = granted;
    } else {
      _notificationsEnabled = false;
    }
    notifyListeners();
  }

  Future<void> clearAllData() async {
    try {
      await _storageService.clearAll();
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error clearing data: $e');
    }
  }

  Future<void> requestAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.requestReview();
  }
}
