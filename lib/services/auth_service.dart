// lib/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal();
  
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  
  User? _currentUser;
  bool _isLoggedIn = false;
  
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (_isLoggedIn) {
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        try {
          _currentUser = User.fromMap(json.decode(userJson));
        } catch (e) {
          print('Error parsing user data: $e');
          await logout(); // Clear corrupted data
        }
      }
    }
  }
  
  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Basic validation
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }
      
      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }
      
      // Create demo user (in real app, verify credentials from API)
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@').first,
        createdAt: DateTime.now(),
      );
      
      _isLoggedIn = true;
      
      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userKey, json.encode(_currentUser!.toMap()));
      
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  Future<bool> signup(String email, String password, String name) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Basic validation
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw Exception('All fields are required');
      }
      
      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }
      
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }
      
      // Create new user
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      _isLoggedIn = true;
      
      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userKey, json.encode(_currentUser!.toMap()));
      
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_isLoggedInKey);
    
    _currentUser = null;
    _isLoggedIn = false;
  }
  
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  
  Future<void> updateUserProfile(String name, {String? profileImageUrl}) async {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        createdAt: _currentUser!.createdAt,
      );
      
      // Update in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(_currentUser!.toMap()));
    }
  }
}