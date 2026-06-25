class ReverseCardModel {
  final String id;
  final String title;
  final String category;
  final String reason;
  final String date;
  final double amount; // <-- додано
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;

  ReverseCardModel({
    required this.id,
    required this.title,
    required this.category,
    required this.reason,
    required this.date,
    required this.amount, // <-- додано
    this.notes,
    this.photoPath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'reason': reason,
    'date': date,
    'amount': amount, // <-- додано
    'notes': notes,
    'photoPath': photoPath,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ReverseCardModel.fromJson(Map<String, dynamic> json) =>
      ReverseCardModel(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        reason: json['reason'],
        date: json['date'],
        amount: (json['amount'] ?? 0).toDouble(), // <-- додано
        notes: json['notes'],
        photoPath: json['photoPath'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  ReverseCardModel copyWith({
    String? id,
    String? title,
    String? category,
    String? reason,
    String? date,
    double? amount, // <-- додано
    String? notes,
    String? photoPath,
    DateTime? createdAt,
  }) => ReverseCardModel(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    reason: reason ?? this.reason,
    date: date ?? this.date,
    amount: amount ?? this.amount, // <-- додано
    notes: notes ?? this.notes,
    photoPath: photoPath ?? this.photoPath,
    createdAt: createdAt ?? this.createdAt,
  );
}
