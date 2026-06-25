import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';

class PreloaderViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;

  PreloaderViewModel(this._storageService);

  Future<String> initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _storageService.getUser();

      // Если пользователь существует И onboarding завершен - идем в home
      if (user != null && user.onboardingCompleted == true) {
        return '/home';
      }

      // Иначе - onboarding
      return '/onboarding';
    } catch (e) {
      // ignore: avoid_print
      print('Preloader error: $e');
      return '/onboarding';
    }
  }
}
