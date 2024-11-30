import 'package:agripas/services/authService.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart'; // Import des couleurs

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final authService = AuthService();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> endBoarding() async {
    String? userToken =await authService.getToken();
    if(userToken != null){
    Navigator.pushReplacementNamed(context, '/home'); // Redirection vers Home via route
    }
    else{
      Navigator.pushReplacementNamed(context, '/home');
      // Navigator.pushReplacementNamed(context, '/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> onboardingPages = [
      _buildPage(
        title: "Bienvenue sur Agripas",
        description: "Simplifiez la gestion agricole grâce à des outils intelligents. Accédez à des conseils pratiques, des prévisions météo détaillées, et une analyse approfondie pour vos cultures.",
        imagePath: "assets/images/onboarding1.jpg",
        backgroundColor: AppColors.blue,
      ),
      _buildPage(
        title: "Cultivez l’avenir avec Agripas",
        description: "Profitez d’une technologie avancée pour maximiser votre productivité agricole. Obtenez des données en temps réel et des solutions adaptées.",
        imagePath: "assets/images/onboarding2.jpg",
        backgroundColor: AppColors.green,
      ),
      _buildPage(
        title: "Prenez les bonnes décisions",
        description: "Prenez les meilleures décisions grâce à des données précises sur les conditions climatiques et des recommandations pour vos cultures.",
        imagePath: "assets/images/onboarding3.jpg",
        backgroundColor: AppColors.blue,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Pages d'Onboarding
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return onboardingPages[index];
                },
              ),
            ),

            // Indicateurs de progression
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bouton "Suivant" ou "Commencer"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _currentPage == onboardingPages.length - 1
                    ? endBoarding // Redirection vers Home
                    : () {
                        // Aller à la page suivante
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _currentPage == onboardingPages.length - 1
                      ? "Commencer"
                      : "Suivant",
                  style: const TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper pour une page d'Onboarding
  Widget _buildPage({
    required String title,
    required String description,
    required String imagePath,
    required Color backgroundColor,
  }) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
