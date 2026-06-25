// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/user_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;

  OnboardingViewModel(this._storageService);

  Future<void> completeOnboarding() async {
    try {
      final user = UserModel(
        id: const Uuid().v4(),
        name: null,
        photoPath: null,
        onboardingCompleted: true,
        notificationsEnabled: true,
        createdAt: DateTime.now(), // <-- додай це
      );

      await _storageService.saveUser(user);
      print('Onboarding completed, user saved: ${user.onboardingCompleted}');
      notifyListeners();
    } catch (e) {
      print('Error completing onboarding: $e');
      rethrow;
    }
  }
}
