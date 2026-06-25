class AppConstants {
  // Validation
  static const int textMinLength = 2;
  static const int textMaxLength = 64;
  static const int maxImageSizeMb = 5;
  static const double maxNumericValue = 9999;

  // Shared Preferences keys
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyUserName = 'user_name';
  static const String keyUserPhoto = 'user_photo';
  static const String keyTheme = 'theme';
  static const String keyNotifications = 'notifications_enabled';
  static const String keyReverseCards = 'reverse_cards';
  static const String keyGoal = 'user_goal';

  // Categories
  static const List<String> categories = [
    'General',
    'Food',
    'Clothing',
    'Electronics',
    'Entertainment',
    'Beauty',
    'Sport',
    'Other',
  ];

  // Rating
  static const int ratingDaysThreshold = 7;
  static const int ratingCardsThreshold = 5;

  // Share & Privacy
  static const String privacyPolicyUrl = 'https://google.com';
  static const String shareText = 'Try this app! :)';
}
