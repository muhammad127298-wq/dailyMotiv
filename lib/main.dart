import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/favorite_manager.dart'; // ADD THIS IMPORT


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DailyMotiv',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      // CHANGE: Always show SplashScreen first, then navigate
      home: const SplashScreen(),
      // Optional: Define routes for clarity
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}