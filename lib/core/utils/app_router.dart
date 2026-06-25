import 'package:flutter/material.dart';
import '../../presentation/screens/preloader/preloader_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/home/home_screen.dart';

class AppRouter {
  static const String preloader = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String createEditCard = '/create-edit-card';
  static const String reverseList = '/reverse-list';
  static const String detail = '/detail';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case preloader:
        return MaterialPageRoute(builder: (_) => const PreloaderScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for $settings.name')),
          ),
        );
    }
  }
}
