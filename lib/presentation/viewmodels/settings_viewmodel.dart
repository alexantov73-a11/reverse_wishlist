import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../data/services/local_storage_service.dart';

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
    _notificationsEnabled = value;
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
