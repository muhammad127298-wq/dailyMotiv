// lib/screens/category_quotes_screen.dart
import 'package:flutter/material.dart';
import '../data/quotes_data.dart';
import '../models/quote_model.dart';
import '../utils/favorite_manager.dart';

class CategoryQuotesScreen extends StatefulWidget {
  final String categoryName;
  final String categoryTitle;
  final Color categoryColor;

  const CategoryQuotesScreen({
    super.key,
    required this.categoryName,
    required this.categoryTitle,
    required this.categoryColor,
  });

  @override
  State<CategoryQuotesScreen> createState() => _CategoryQuotesScreenState();
}

class _CategoryQuotesScreenState extends State<CategoryQuotesScreen> {
  List<Quote> _categoryQuotes = [];
  int _currentQuoteIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryQuotes();
  }

  void _loadCategoryQuotes() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      final quotes = QuotesData.getQuotesByCategory(widget.categoryName);
      setState(() {
        _categoryQuotes = quotes;
        _currentQuoteIndex = 0;
        _isLoading = false;
      });
    });
  }

  void _nextQuote() {
    if (_categoryQuotes.isEmpty) return;
    
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _categoryQuotes.length;
    });
  }

  void _previousQuote() {
    if (_categoryQuotes.isEmpty) return;
    
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex - 1 + _categoryQuotes.length) % _categoryQuotes.length;
    });
  }
  
  Future<void> _toggleFavorite() async {
    if (_categoryQuotes.isEmpty) return;
    
    final currentQuote = _categoryQuotes[_currentQuoteIndex];
    await FavoriteManager().toggleFavorite(currentQuote.id);
    
    // Show feedback
    final snackBar = SnackBar(
      content: Text(
        currentQuote.isFavorite 
          ? 'Added to favorites!' 
          : 'Removed from favorites',
      ),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    // Update UI
    setState(() {});
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.categoryColor,
        elevation: 0,
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
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
        backgroundColor: widget.categoryColor,
        elevation: 0,
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No quotes found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'There are no quotes available in the ${widget.categoryTitle.toLowerCase()} category',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.categoryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteContent(Quote currentQuote) {
    final colorScheme = QuotesData.getColorScheme(currentQuote.colorScheme);
    final gradientStart = Color(colorScheme['gradientStart'] ?? 0xFF008B8B);
    final gradientEnd = Color(colorScheme['gradientEnd'] ?? 0xFF20B2AA);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Quote counter
          Text(
            'Quote ${_currentQuoteIndex + 1} of ${_categoryQuotes.length}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Quote card
          Card(
            elevation: 8,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradientStart, gradientEnd],
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.format_quote,
                    size: 40,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 20),
                  
                  // Quote text
                  Text(
                    currentQuote.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Favorite button and decorative icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Favorite button
                      IconButton(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          currentQuote.isFavorite 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                          color: currentQuote.isFavorite ? Colors.red : Colors.white70,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      
                      // Decorative quote icon
                      const Icon(
                        Icons.format_quote,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Navigation buttons
          Row(
            children: [
              // Previous button
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _previousQuote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.categoryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.arrow_back, size: 24),
                    label: const Text('Previous'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Next button
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _nextQuote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.categoryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.arrow_forward, size: 24),
                    label: const Text('Next'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (_isLoading) {
      return _buildLoadingState();
    }
    
    // Empty state
    if (_categoryQuotes.isEmpty) {
      return _buildEmptyState();
    }
    
    // Main content
    final currentQuote = _categoryQuotes[_currentQuoteIndex];
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.categoryColor,
        elevation: 0,
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: _buildQuoteContent(currentQuote),
    );
  }
}