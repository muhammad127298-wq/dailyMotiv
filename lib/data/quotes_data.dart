// lib/data/quotes_data.dart
import 'dart:math';
import '../models/quote_model.dart';

class QuotesData {
  // Color schemes for different quotes - now only gradient colors
  static final List<Map<String, dynamic>> colorSchemes = [
    {
      'name': 'teal',
      'gradientStart': 0xFF008B8B,
      'gradientEnd': 0xFF20B2AA,
    },
    {
      'name': 'purple',
      'gradientStart': 0xFF6A5ACD,
      'gradientEnd': 0xFF9370DB,
    },
    {
      'name': 'green',
      'gradientStart': 0xFF228B22,
      'gradientEnd': 0xFF32CD32,
    },
    {
      'name': 'orange',
      'gradientStart': 0xFFFF8C00,
      'gradientEnd': 0xFFFFA500,
    },
    {
      'name': 'blue',
      'gradientStart': 0xFF1E90FF,
      'gradientEnd': 0xFF87CEFA,
    },
    {
      'name': 'red',
      'gradientStart': 0xFFDC143C,
      'gradientEnd': 0xFFFF6347,
    },
    {
      'name': 'pink',
      'gradientStart': 0xFFDB7093,
      'gradientEnd': 0xFFFF69B4,
    },
    {
      'name': 'deepBlue',
      'gradientStart': 0xFF191970,
      'gradientEnd': 0xFF4169E1,
    },
  ];

  // Categorized quotes
  static final List<Quote> quotes = [
    // SUCCESS category
    Quote(id: 1, text: "Believe in Yourself and all that you are", colorScheme: 'teal', category: 'success'),
    Quote(id: 2, text: "The only way to do great work is to love what you do", colorScheme: 'purple', category: 'success'),
    Quote(id: 3, text: "The future belongs to those who believe in the beauty of their dreams", colorScheme: 'orange', category: 'success'),
    Quote(id: 4, text: "Success is not final, failure is not fatal: it is the courage to continue that counts", colorScheme: 'blue', category: 'success'),
    Quote(id: 5, text: "Don't watch the clock; do what it does. Keep going", colorScheme: 'teal', category: 'success'),
    
    // POSITIVITY category
    Quote(id: 6, text: "Your time is limited, don't waste it living someone else's life", colorScheme: 'green', category: 'positivity'),
    Quote(id: 7, text: "You are never too old to set another goal or to dream a new dream", colorScheme: 'green', category: 'positivity'),
    Quote(id: 8, text: "The way to get started is to quit talking and begin doing", colorScheme: 'orange', category: 'positivity'),
    Quote(id: 9, text: "Believe you can and you're halfway there", colorScheme: 'pink', category: 'positivity'),
    Quote(id: 10, text: "The mind is everything. What you think you become", colorScheme: 'purple', category: 'positivity'),
    
    // STUDY category
    Quote(id: 11, text: "It does not matter how slowly you go as long as you do not stop", colorScheme: 'blue', category: 'study'),
    Quote(id: 12, text: "The journey of a thousand miles begins with one step", colorScheme: 'red', category: 'study'),
    Quote(id: 13, text: "The only limit to our realization of tomorrow will be our doubts of today", colorScheme: 'deepBlue', category: 'study'),
    Quote(id: 14, text: "I have not failed. I've just found 10,000 ways that won't work", colorScheme: 'green', category: 'study'),
    Quote(id: 15, text: "Start where you are. Use what you have. Do what you can", colorScheme: 'teal', category: 'study'),
    
    // LOVE category
    Quote(id: 16, text: "Love all, trust a few, do wrong to none", colorScheme: 'pink', category: 'love'),
    Quote(id: 17, text: "The best thing to hold onto in life is each other", colorScheme: 'red', category: 'love'),
    Quote(id: 18, text: "Where there is love there is life", colorScheme: 'pink', category: 'love'),
    Quote(id: 19, text: "Love is composed of a single soul inhabiting two bodies", colorScheme: 'red', category: 'love'),
    Quote(id: 20, text: "To love and be loved is to feel the sun from both sides", colorScheme: 'pink', category: 'love'),
  ];

  static final Random _random = Random();
  static Quote getRandomQuote() {
  // Simple random selection without tracking last quote
  final randomIndex = _random.nextInt(quotes.length);
  final newQuote = quotes[randomIndex];
  
  return Quote(
    id: newQuote.id,
    text: newQuote.text,
    colorScheme: newQuote.colorScheme,
    category: newQuote.category,
  );
}

  // Get quotes by specific category
  static List<Quote> getQuotesByCategory(String category) {
    return quotes.where((quote) => quote.category == category).toList();
  }

  // Get random quote from specific category
  static Quote getRandomQuoteByCategory(String category) {
    final categoryQuotes = getQuotesByCategory(category);
    if (categoryQuotes.isEmpty) {
      return getRandomQuote();
    }
    final randomIndex = _random.nextInt(categoryQuotes.length);
    return Quote(
      id: categoryQuotes[randomIndex].id,
      text: categoryQuotes[randomIndex].text,
      colorScheme: categoryQuotes[randomIndex].colorScheme,
      category: categoryQuotes[randomIndex].category,
    );
  }

  static Map<String, dynamic> getColorScheme(String schemeName) {
    return colorSchemes.firstWhere(
      (scheme) => scheme['name'] == schemeName,
      orElse: () => colorSchemes[0],
    );
  }

  static List<Quote> getAllQuotes() {
    return quotes;
  }
}