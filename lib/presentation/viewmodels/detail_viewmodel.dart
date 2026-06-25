import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/reverse_card_model.dart';

class DetailViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  ReverseCardModel? _card;
  bool _isLoading = false;

  DetailViewModel(this._storageService);

  ReverseCardModel? get card => _card;
  bool get isLoading => _isLoading;

  Future<void> loadCard(String cardId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final cards = _storageService.getReverseCards();
      _card = cards.firstWhere((c) => c.id == cardId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCard(String cardId) async {
    if (_card == null) return;

    try {
      final cards = _storageService.getReverseCards();
      cards.removeWhere((c) => c.id == _card!.id);
      await _storageService.saveReverseCards(cards);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
