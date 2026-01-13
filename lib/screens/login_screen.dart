// screens/login_screen.dart - UPDATED WITH GOOGLE LOGO
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize auth service
    _authService.init();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
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

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final success = await _authService.login(email, password);
      
      if (success) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
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

  void _loginWithGoogle() {
    // For demo - simulate Google login
    _emailController.text = 'demo@gmail.com';
    _passwordController.text = 'password';
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,

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
                'Login your account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Welcome back! Log in to resume your reading journey',
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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    _showForgotPasswordDialog(context);
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF008B8B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
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
                          'Login',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
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
                  onPressed: _isLoading ? null : _loginWithGoogle,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.black87,
                  ),
                  icon: Image.asset(
                    'assets/images/google_logo.png', // Changed to Google logo
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to Google icon if image not found
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
                    'Login with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Password'),
        content: const Text(
            'Enter your email address and we\'ll send you a link to reset your password.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset link sent to your email.'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF008B8B),
            ),
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }
}