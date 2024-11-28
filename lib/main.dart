import 'package:agripas/screens/chatBot.dart';
import 'package:agripas/screens/forum.dart';
import 'package:agripas/screens/irrigations.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart'; 
import 'utils/colors.dart'; 
import 'screens/onboarding.dart'; 
import 'screens/conseilAgricole.dart'; 
import 'screens/diagnostic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/conseilAgricole': (context) => ConseilAgricolePage(), // Route vers la page Conseil Agricole
        '/irrigations': (context) => const IrrigationPage(),
        '/chat': (context) => ChatBotApp(),
        '/diagnostic': (context) => const DiagnosticPage(),
        '/forum': (context) => const ForumPage()


      },
    );
  }
}
