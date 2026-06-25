import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/camera_service.dart';
import 'presentation/screens/preloader/preloader_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/create_edit_card/create_edit_card_screen.dart';
import 'presentation/screens/detail/detail_screen.dart';
import 'presentation/viewmodels/preloader_viewmodel.dart';
import 'presentation/viewmodels/onboarding_viewmodel.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/create_edit_card_viewmodel.dart';
import 'presentation/viewmodels/reverse_list_viewmodel.dart';
import 'presentation/viewmodels/detail_viewmodel.dart';
import 'presentation/viewmodels/analytics_viewmodel.dart';
import 'presentation/viewmodels/profile_viewmodel.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/viewmodels/theme_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = LocalStorageService();
  final cameraService = CameraService();

  await storageService.init();
  await cameraService.init();

  runApp(MyApp(storageService: storageService, cameraService: cameraService));
}

class MyApp extends StatelessWidget {
  final LocalStorageService storageService;
  final CameraService cameraService;

  const MyApp({
    super.key,
    required this.storageService,
    required this.cameraService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorageService>(create: (_) => storageService),
        Provider<CameraService>(create: (_) => cameraService),
        ChangeNotifierProvider(create: (_) => ThemeViewModel(storageService)),
        ChangeNotifierProvider(
          create: (_) => PreloaderViewModel(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(storageService),
        ),
        ChangeNotifierProvider(create: (_) => HomeViewModel(storageService)),
        ChangeNotifierProvider(
          create: (_) => CreateEditCardViewModel(storageService, cameraService),
        ),
        ChangeNotifierProvider(
          create: (_) => ReverseListViewModel(storageService),
        ),
        ChangeNotifierProvider(create: (_) => DetailViewModel(storageService)),
        ChangeNotifierProvider(
          create: (_) => AnalyticsViewModel(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(storageService, cameraService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(storageService),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Reverse Wishlist',
            theme: context.watch<ThemeViewModel>().getThemeData(),
            debugShowCheckedModeBanner: false,
            home: const PreloaderScreen(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/onboarding':
                  return MaterialPageRoute(
                    builder: (_) => const OnboardingScreen(),
                  );
                case '/home':
                  return MaterialPageRoute(builder: (_) => const HomeScreen());
                case '/create-edit-card':
                  return MaterialPageRoute(
                    builder: (_) => CreateEditCardScreen(
                      cardId: settings.arguments as String?,
                    ),
                  );
                case '/detail':
                  return MaterialPageRoute(
                    builder: (_) =>
                        DetailScreen(cardId: settings.arguments as String),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const PreloaderScreen(),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
