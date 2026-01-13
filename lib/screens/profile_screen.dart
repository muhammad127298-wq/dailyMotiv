// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      _nameController.text = user.name;
    }
  }

  void _saveProfile() async {
    if (_nameController.text.isNotEmpty) {
      await _authService.updateUserProfile(_nameController.text);
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _authService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final userEmail = user?.email ?? 'Not logged in';
    final userName = user?.name ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008B8B),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),

        automaticallyImplyLeading: false,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: const Color(0xFF008B8B).withOpacity(0.1),
                    child: user?.profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              user!.profileImageUrl!,
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 80,
                            color: Color(0xFF008B8B),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Name field - editable when editing
                if (_isEditing)
                  Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF008B8B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Save'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  _loadUserData(); // Reset changes
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  )
                else
                  Column(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: 8),
                if (user != null)
                  Text(
                    'Member since ${user.createdAt.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                const SizedBox(height: 48),
                _buildMenuButton(
                  context: context,
                  icon: Icons.calendar_today,
                  label: '7 Days Motivation',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('7 Days Motivation feature coming soon!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context: context,
                  icon: Icons.notifications,
                  label: 'Set Daily Reminder',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reminder settings coming soon!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context: context,
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                  isDestructive: true,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive 
              ? Colors.red.shade50 
              : Colors.grey.shade50,
          foregroundColor: isDestructive 
              ? Colors.red.shade700 
              : Colors.black87,
          elevation: 0,
          shape: const StadiumBorder(),
          side: BorderSide(
            color: isDestructive 
                ? Colors.red.shade200 
                : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive 
                  ? Colors.red.shade700 
                  : const Color(0xFF008B8B),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDestructive 
                    ? Colors.red.shade700 
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}