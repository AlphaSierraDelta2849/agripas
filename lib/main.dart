import 'package:agripas/auth/auth.dart';
import 'package:agripas/panier/cart.dart';
import 'package:agripas/screens/chatBot.dart';
import 'package:agripas/screens/forum.dart';
import 'package:agripas/screens/irrigations.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart'; 
import 'screens/conseilAgricole.dart'; 
import 'screens/diagnostic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:agripas/auth/root.dart';
import 'package:agripas/screens/market.dart';
import 'package:agripas/panier/cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agripas',
      debugShowCheckedModeBanner: false,
      home: const RootPage(),
      routes: {
        '/auth': (context) => const AuthPage(), 
        '/home': (context) => const HomePage(), 
        '/conseilAgricole': (context) => ConseilAgricolePage(), 
        '/irrigations': (context) => const IrrigationPage(),
        '/chat': (context) => ChatBotApp(),
        '/diagnostic': (context) => const DiagnosticPage(),
        '/forum': (context) => const ForumPage(),
        '/market': (context) => const MarketPage(),
        '/cart': (context) => const CartPage()
      },
    );
  }
}