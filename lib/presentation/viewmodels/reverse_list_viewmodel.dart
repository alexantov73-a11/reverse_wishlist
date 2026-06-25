import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/reverse_card_model.dart';

class ReverseListViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  List<ReverseCardModel> _cards = [];
  List<ReverseCardModel> _filteredCards = [];
  String _filterCategory = 'All';
  bool _isLoading = false;

  ReverseListViewModel(this._storageService);

  List<ReverseCardModel> get filteredCards => _filteredCards;
  String get filterCategory => _filterCategory;
  bool get isLoading => _isLoading;

  Future<void> loadCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cards = _storageService.getReverseCards();
      _applyFilter();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void setFilterCategory(String category) {
    _filterCategory = category;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_filterCategory == 'All') {
      _filteredCards = _cards;
    } else {
      _filteredCards = _cards
          .where((c) => c.category == _filterCategory)
          .toList();
    }
    _filteredCards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> deleteCard(String cardId) async {
    try {
      _cards.removeWhere((c) => c.id == cardId);
      await _storageService.saveReverseCards(_cards);
      _applyFilter();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
