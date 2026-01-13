// lib/screens/explore_screen.dart (or category screen)
import 'package:flutter/material.dart';
import '../data/quotes_data.dart';
import '../models/quote_model.dart';
import '../services/collection_manager.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final CollectionManager _collectionManager = CollectionManager();
  String _selectedCategory = 'success';
  
  final List<String> categories = [
    'success',
    'positivity',
    'study',
    'love',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Category selector
          Container(
            height: 70,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: ChoiceChip(
                    label: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF008B8B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF008B8B),
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Quotes list
          Expanded(
            child: _buildQuotesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesList() {
    final categoryQuotes = QuotesData.getQuotesByCategory(_selectedCategory);
    
    if (categoryQuotes.isEmpty) {
      return Center(
        child: Text(
          'No quotes found for $_selectedCategory',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categoryQuotes.length,
      itemBuilder: (context, index) {
        final quote = categoryQuotes[index];
        final colorScheme = QuotesData.getColorScheme(quote.colorScheme);
        final gradientStart = Color(colorScheme['gradientStart'] ?? 0xFF008B8B);
        final gradientEnd = Color(colorScheme['gradientEnd'] ?? 0xFF20B2AA);
        final isFavorite = _collectionManager.isInCollection(quote.id);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradientStart.withOpacity(0.1),
                  gradientEnd.withOpacity(0.1),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      await _collectionManager.addToCollection(quote);
                      setState(() {}); // Refresh UI
                      
                      // Show feedback
                      final snackBar = SnackBar(
                        content: Text(
                          isFavorite ? 'Removed from favorites' : 'Added to favorites!',
                        ),
                        duration: const Duration(seconds: 1),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
}