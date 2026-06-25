import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/reverse_card_model.dart';
import '../models/user_model.dart';
import '../models/analytics_model.dart';
import '../../core/constants/app_constants.dart';

class LocalStorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User methods
  Future<void> saveUser(UserModel user) async {
    await _prefs.setString('user', jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final json = _prefs.getString('user');
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }

  bool isDarkMode() {
    return _prefs.getBool('isDarkMode') ?? false;
  }

  Future<bool> setDarkMode(bool value) async {
    return await _prefs.setBool('isDarkMode', value);
  }

  // Onboarding
  Future<void> setOnboardingDone() async {
    await _prefs.setBool(AppConstants.keyOnboardingDone, true);
  }

  bool isOnboardingDone() =>
      _prefs.getBool(AppConstants.keyOnboardingDone) ?? false;

  // Reverse Cards
  Future<void> saveReverseCards(List<ReverseCardModel> cards) async {
    final json = jsonEncode(cards.map((c) => c.toJson()).toList());
    await _prefs.setString(AppConstants.keyReverseCards, json);
  }

  List<ReverseCardModel> getReverseCards() {
    final json = _prefs.getString(AppConstants.keyReverseCards);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((c) => ReverseCardModel.fromJson(c)).toList();
  }

  // Analytics
  Future<void> saveAnalytics(AnalyticsModel analytics) async {
    await _prefs.setString('analytics', jsonEncode(analytics.toJson()));
  }

  AnalyticsModel getAnalytics() {
    final json = _prefs.getString('analytics');
    if (json == null) return AnalyticsModel.empty();
    return AnalyticsModel.fromJson(jsonDecode(json));
  }

  // Clear all
  Future<void> clearAll() async {
    try {
      await _prefs.clear();
    } catch (e) {
      // ignore: avoid_print
      print('Error clearing SharedPreferences: $e');
    }
  }
}
