// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/home_content.dart';
import 'my_collections_screen.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';
import '../services/collection_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final CollectionManager _collectionManager = CollectionManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008B8B),
        elevation: 0,
        title: const Text(
          'DailyMotiv',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Home tab
          HomeContent(
            onFavoriteToggled: () {
              // Just create a new instance of MyCollectionsScreen
              // to force it to refresh when we switch to it
              setState(() {});
            },
          ),
          
          // Explore tab
          const ExploreScreen(),
          
          // My Collections tab - ALWAYS PASS THE SAME CollectionManager
          MyCollectionsScreen(collectionManager: _collectionManager),
          
          // Profile tab
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF008B8B),
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'My Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}