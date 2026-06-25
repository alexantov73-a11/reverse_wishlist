import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/camera_service.dart';
import '../../data/models/reverse_card_model.dart';
import 'package:uuid/uuid.dart';

class CreateEditCardViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  final CameraService _cameraService;

  String _photoPath = '';
  String _title = '';
  String _category = 'General';
  String _reason = '';
  String _date = '';
  double _amount = 0.0;
  String _notes = '';
  bool _isLoading = false;

  CreateEditCardViewModel(this._storageService, this._cameraService);

  String get photoPath => _photoPath;
  String get title => _title;
  String get category => _category;
  String get reason => _reason;
  String get date => _date;
  double get amount => _amount;
  String get notes => _notes;
  bool get isLoading => _isLoading;

  void setPhoto(String path) {
    _photoPath = path;
    notifyListeners();
  }

  void setTitle(String value) => _title = value;
  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setReason(String value) => _reason = value;
  void setDate(String value) {
    _date = value;
    notifyListeners();
  }

  void setAmount(double value) {
    _amount = value;
    notifyListeners();
  }

  void setNotes(String value) => _notes = value;

  Future<String?> pickFromCamera() => _cameraService.pickImageFromCamera();
  Future<String?> pickFromGallery() => _cameraService.pickImageFromGallery();

  Future<void> saveCard() async {
    if (_photoPath.isEmpty ||
        _title.isEmpty ||
        _reason.isEmpty ||
        _date.isEmpty) {
      throw Exception('Please fill all required fields');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final cards = _storageService.getReverseCards();

      final newCard = ReverseCardModel(
        id: const Uuid().v4(),
        title: _title,
        category: _category,
        reason: _reason,
        date: _date,
        amount: _amount,
        notes: _notes.isEmpty ? null : _notes,
        photoPath: _photoPath,
        createdAt: DateTime.now(),
      );

      cards.add(newCard);
      await _storageService.saveReverseCards(cards);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void reset() {
    _photoPath = '';
    _title = '';
    _category = 'General';
    _reason = '';
    _date = '';
    _amount = 0.0;
    _notes = '';
    notifyListeners();
  }
}
