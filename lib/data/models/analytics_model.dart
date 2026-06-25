class AnalyticsModel {
  final int totalCards;
  final int totalSavings;
  final Map<String, int> categoryStats;
  final DateTime lastUpdated;

  AnalyticsModel({
    required this.totalCards,
    required this.totalSavings,
    required this.categoryStats,
    required this.lastUpdated,
  });

  factory AnalyticsModel.empty() => AnalyticsModel(
    totalCards: 0,
    totalSavings: 0,
    categoryStats: {},
    lastUpdated: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'totalCards': totalCards,
    'totalSavings': totalSavings,
    'categoryStats': categoryStats,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
    totalCards: json['totalCards'] ?? 0,
    totalSavings: json['totalSavings'] ?? 0,
    categoryStats: Map<String, int>.from(json['categoryStats'] ?? {}),
    lastUpdated: json['lastUpdated'] != null
        ? DateTime.parse(json['lastUpdated'])
        : DateTime.now(),
  );
}
