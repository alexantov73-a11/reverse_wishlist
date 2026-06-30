import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/reverse_card_model.dart';
import '../../data/models/analytics_model.dart';
import '../../data/services/notification_service.dart';

class HomeViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  List<ReverseCardModel> _reverseCards = [];
  AnalyticsModel _analytics = AnalyticsModel.empty();
  bool _isLoading = false;

  HomeViewModel(this._storageService);

  List<ReverseCardModel> get reverseCards => _reverseCards;
  AnalyticsModel get analytics => _analytics;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reverseCards = _storageService.getReverseCards();

      // Calculate totals from cards
      double totalAmount = 0;
      final categoryStats = <String, int>{};

      for (var card in _reverseCards) {
        totalAmount += card.amount;
        categoryStats[card.category] = (categoryStats[card.category] ?? 0) + 1;
      }

      _analytics = AnalyticsModel(
        totalCards: _reverseCards.length,
        totalSavings: totalAmount.toInt(),
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

  Future<void> deleteCard(String cardId) async {
    try {
      _reverseCards.removeWhere((card) => card.id == cardId);
      await _storageService.saveReverseCards(_reverseCards);
      await loadData();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> scheduleWeeklyReminder() async {
    final notificationService = NotificationService();

    // Кожен вівторок в 9:00 AM
    await notificationService.scheduleWeeklyReminder(
      id: 100,
      title: '📋 Weekly Check-in',
      body: "How many impulse purchases did you refuse this week?",
      dayOfWeek: 2, // Tuesday
      hour: 9,
      minute: 0,
    );
  }

  void refresh() => loadData();
}
