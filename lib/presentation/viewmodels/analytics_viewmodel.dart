import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/analytics_model.dart';

class AnalyticsViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  AnalyticsModel _analytics = AnalyticsModel.empty();
  bool _isLoading = false;

  AnalyticsViewModel(this._storageService);

  AnalyticsModel get analytics => _analytics;
  bool get isLoading => _isLoading;

  Future<void> loadAnalytics() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cards = _storageService.getReverseCards();
      final categoryStats = <String, int>{};

      for (var card in cards) {
        categoryStats[card.category] = (categoryStats[card.category] ?? 0) + 1;
      }

      _analytics = AnalyticsModel(
        totalCards: cards.length,
        totalSavings: cards.length * 100,
        categoryStats: categoryStats,
        lastUpdated: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Map<String, int> getCategoryStats() => _analytics.categoryStats;

  int getTotalCards() => _analytics.totalCards;

  int getTotalSavings() => _analytics.totalSavings;
}
