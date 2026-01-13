// lib/screens/splash_screen.dart - MODIFIED VERSION

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Initialize auth service
    final authService = AuthService();
    await authService.init();
    
    await Future.delayed(const Duration(seconds: 5));
    
    // Check auth status
    final isLoggedIn = authService.isLoggedIn;
    
    if (mounted) {
      // Navigate based on auth status with smooth transition
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => isLoggedIn 
              ? const HomeScreen() 
              : const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top 60% - Silhouette Image
          Expanded(
            flex: 6, // 60% of screen
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black, // Fallback color if image fails
              ),
              child: Image.asset(
                'assets/images/silhouette_peak.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback UI if image not found
                  return Container(
                    color: Colors.blueGrey,
                    child: const Center(
                      child: Icon(
                        Icons.landscape,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Bottom 40% - Teal/Blue Color Block with App Title
          Expanded(
            flex: 4, // 40% of screen
            child: Container(
              width: double.infinity,
              color: const Color(0xFF008B8B), // Teal color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Title
                    const Text(
                      'DailyMotiv',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Loading indicator
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Loading text
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}