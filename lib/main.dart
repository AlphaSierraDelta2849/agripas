import 'package:agripas/screens/chatBot.dart';
import 'package:agripas/screens/irrigations.dart';
import 'package:agripas/screens/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home.dart'; // Import de la page d'accueil
import 'utils/colors.dart'; // Import des couleurs
import 'screens/onboarding.dart'; // Import de l'onboarding
import 'screens/conseilAgricole.dart'; // Import de la page Conseil Agricole

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agripas',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.white),
          bodyMedium: TextStyle(color: AppColors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(), // Page Onboarding comme écran principal
      routes: {
        '/home': (context) => const HomePage(), // Route vers la page Home
        '/conseilAgricole': (context) =>
            const ConseilAgricolePage(), // Route vers la page Conseil Agricole
        '/irrigations': (context) => const IrrigationPage(),
        '/signup': (context) => PhoneAuthScreen(),
        '/chat': (context) => ChatBotApp(),
      },
    );
  }
}
