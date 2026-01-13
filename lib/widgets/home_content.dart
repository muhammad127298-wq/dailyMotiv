// lib/widgets/home_content.dart
import 'package:flutter/material.dart';
import '../data/quotes_data.dart';
import '../models/quote_model.dart';
import '../services/collection_manager.dart';

class HomeContent extends StatefulWidget {
  final VoidCallback onFavoriteToggled;
  
  const HomeContent({
    super.key,
    required this.onFavoriteToggled,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Quote currentQuote;
  late Map<String, dynamic> currentColorScheme;
  final CollectionManager _collectionManager = CollectionManager();

  @override
  void initState() {
    super.initState();
    _loadNewQuote();
  }

  void _loadNewQuote() {
    setState(() {
      currentQuote = QuotesData.getRandomQuote();
      currentColorScheme = QuotesData.getColorScheme(currentQuote.colorScheme);
    });
  }

  Future<void> _toggleFavorite() async {
    // Simply toggle using CollectionManager
    await _collectionManager.addToCollection(currentQuote);
    
    // Get current status
    final isNowFavorite = _collectionManager.isInCollection(currentQuote.id);
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowFavorite ? '✓ Added to favorites!' : '✗ Removed from favorites',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
    
    // Notify parent
    widget.onFavoriteToggled();
    
    // Refresh this widget
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final gradientStart = Color(currentColorScheme['gradientStart'] ?? 0xFF008B8B);
    final gradientEnd = Color(currentColorScheme['gradientEnd'] ?? 0xFF20B2AA);
    
    // Check current favorite status
    final isFavorite = _collectionManager.isInCollection(currentQuote.id);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
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
                    colors: [
                      gradientStart,
                      gradientEnd,
                    ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white70,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 20),
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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadNewQuote,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Quote'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008B8B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Share functionality
                  },
                  icon: const Icon(Icons.share),
                  iconSize: 28,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF008B8B)),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}