// lib/screens/my_collections_screen.dart - COMPLETE FIXED VERSION
import 'package:flutter/material.dart';
import '../services/collection_manager.dart';
import '../models/quote_model.dart';
import '../data/quotes_data.dart';

class MyCollectionsScreen extends StatefulWidget {
  final CollectionManager collectionManager;
  
  const MyCollectionsScreen({
    super.key,
    required this.collectionManager,
  });

  @override
  State<MyCollectionsScreen> createState() => _MyCollectionsScreenState();
}

class _MyCollectionsScreenState extends State<MyCollectionsScreen> {
  List<Quote> _favoriteQuotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading for better UX
    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() {
      _favoriteQuotes = widget.collectionManager.getFavorites();
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(int quoteId) async {
    await widget.collectionManager.removeFromCollection(quoteId);
    await _loadFavorites(); // Reload after toggle
    
    // Show feedback
    const snackBar = SnackBar(
      content: Text('Removed from favorites'),
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    );
    
    // Check if widget is still mounted before showing snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _removeQuote(int id) async {
    await widget.collectionManager.removeFromCollection(id);
    await _loadFavorites(); // Reload after removal
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008B8B),
        elevation: 0,
        title: const Text(
          'My Collection',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF008B8B),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008B8B),
        elevation: 0,
        title: const Text(
          'My Collection',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 80,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 24),
              Text(
                'No Favorites Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the heart icon on quotes to add them here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Navigate to home tab
                  // In a real app, you might want to navigate to home
                  // For now, just reload
                  _loadFavorites();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008B8B),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Explore Quotes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteItem(BuildContext context, Quote quote, int index) {
    final colorScheme = QuotesData.getColorScheme(quote.colorScheme);
    final gradientStart = Color(colorScheme['gradientStart'] ?? 0xFF008B8B);
    final gradientEnd = Color(colorScheme['gradientEnd'] ?? 0xFF20B2AA);

    return Dismissible(
      key: Key('quote_${quote.id}_${quote.text.hashCode}'),
      background: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteDialog(quote.id);
      },
      onDismissed: (direction) {
        _removeQuote(quote.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              gradientStart.withOpacity(0.1), 
              gradientEnd.withOpacity(0.1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: gradientStart.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          title: Text(
            quote.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(quote.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getCategoryColor(quote.category).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    quote.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(quote.category),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Swipe to delete',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 28,
            ),
            onPressed: () {
              _toggleFavorite(quote.id);
            },
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'success':
        return const Color(0xFF4CAF50);
      case 'positivity':
        return const Color(0xFFFFC107);
      case 'study':
        return const Color(0xFF2196F3);
      case 'love':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF008B8B);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }
    
    if (_favoriteQuotes.isEmpty) {
      return _buildEmptyState();
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008B8B),
        elevation: 0,
        title: const Text(
          'My Collection',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () {
              if (_favoriteQuotes.isNotEmpty) {
                _showDeleteAllDialog();
              }
            },
            tooltip: 'Clear All',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_favoriteQuotes.length} saved quote${_favoriteQuotes.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Quotes list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadFavorites,
              color: const Color(0xFF008B8B),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _favoriteQuotes.length,
                itemBuilder: (context, index) {
                  return _buildQuoteItem(context, _favoriteQuotes[index], index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog(int quoteId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Quote'),
        content: const Text('Are you sure you want to remove this quote from your collection?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    
    return shouldDelete ?? false;
  }

  Future<void> _showDeleteAllDialog() async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all quotes from your collection? This action cannot be undone.'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      await widget.collectionManager.clearAll();
      await _loadFavorites();
      
      // Show confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All favorites cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}