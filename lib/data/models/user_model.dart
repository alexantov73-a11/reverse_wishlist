class UserModel {
  final String id;
  final String? name;
  final String? photoPath;
  final bool onboardingCompleted;
  final bool notificationsEnabled;
  final DateTime createdAt;

  UserModel({
    required this.id,
    this.name,
    this.photoPath,
    required this.onboardingCompleted,
    required this.notificationsEnabled,
    required this.createdAt,
  });

  factory UserModel.empty() => UserModel(
    id: '',
    onboardingCompleted: false,
    notificationsEnabled: true,
    createdAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'photoPath': photoPath,
    'onboardingCompleted': onboardingCompleted,
    'notificationsEnabled': notificationsEnabled,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'],
    photoPath: json['photoPath'],
    onboardingCompleted: json['onboardingCompleted'] ?? false,
    notificationsEnabled: json['notificationsEnabled'] ?? true,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? photoPath,
    bool? onboardingCompleted,
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    photoPath: photoPath ?? this.photoPath,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    createdAt: createdAt ?? this.createdAt,
  );
}
