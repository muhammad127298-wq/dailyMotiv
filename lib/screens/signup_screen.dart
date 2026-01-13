// screens/signup_screen.dart - UPDATED VERSION
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _authService.init();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    // Basic validation
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final success = await _authService.signup(email, password, name);
      
      if (success) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // Removed the leading arrow back button
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Create an account and explore a diverse library of captivating stories',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              
              // Error message
              if (_errorMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 20),
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF008B8B),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF008B8B),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF008B8B),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008B8B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Create new account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Color(0xFF008B8B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : () {
                    // Google sign up action
                    _emailController.text = 'demo@gmail.com';
                    _passwordController.text = 'password123';
                    _nameController.text = 'Demo User';
                    _signup();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.black87,
                  ),
                  // Using Google logo from assets like in LoginScreen
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to network image if local asset not found
                      return Image.network(
                        'https://www.google.com/favicon.ico',
                        height: 24,
                        width: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.g_mobiledata,
                            size: 28,
                            color: Colors.black87,
                          );
                        },
                      );
                    },
                  ),
                  label: const Text(
                    'Sign up with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}