import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/services/camera_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  final CameraService _cameraService;
  UserModel? _user;
  bool _isLoading = false;

  ProfileViewModel(this._storageService, this._cameraService);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = _storageService.getUser();
      _user ??= UserModel.empty();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateUserName(String name) async {
    if (_user == null) return;

    try {
      _user = _user!.copyWith(name: name);
      await _storageService.saveUser(_user!);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> pickProfilePhoto() => _cameraService.pickImageFromGallery();

  Future<void> updateProfilePhoto(String photoPath) async {
    if (_user == null) return;

    try {
      _user = _user!.copyWith(photoPath: photoPath);
      await _storageService.saveUser(_user!);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
