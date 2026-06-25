import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/onboarding_viewmodel.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      icon: Icons.shopping_bag,
      title: 'Conscious Consumption',
      description: 'Track items you refused to buy and understand your habits',
    ),
    OnboardingPage(
      icon: Icons.camera_alt,
      title: 'Photo & Notes',
      description: 'Take photos and add reasons for refusing purchases',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: pages.length,
        itemBuilder: (context, index) => _buildPage(pages[index]),
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(page.icon, size: 120, color: Theme.of(context).primaryColor),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              page.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                minimumSize: const Size(70, 44),
              ),
              child: const Text('Back'),
            )
          else
            const SizedBox(width: 70),
          Row(
            children: List.generate(
              pages.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
          if (_currentPage < pages.length - 1)
            ElevatedButton(
              onPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              style: ElevatedButton.styleFrom(minimumSize: const Size(70, 44)),
              child: const Text('Next'),
            )
          else
            ElevatedButton(
              onPressed: () async {
                await context.read<OnboardingViewModel>().completeOnboarding();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(70, 44)),
              child: const Text('Done'),
            ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
