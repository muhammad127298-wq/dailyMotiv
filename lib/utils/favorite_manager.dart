// lib/utils/favorite_manager.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';
import '../data/quotes_data.dart';

class FavoriteManager {
  static const String _favoritesKey = 'favorite_quotes';
  Set<int> _favoriteIds = {};

  // Singleton pattern
  static final FavoriteManager _instance = FavoriteManager._internal();
  
  factory FavoriteManager() {
    return _instance;
  }
  
  FavoriteManager._internal() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteString = prefs.getString(_favoritesKey) ?? '';
      if (favoriteString.isNotEmpty) {
        _favoriteIds = favoriteString.split(',').where((id) => id.isNotEmpty).map(int.parse).toSet();
      } else {
        _favoriteIds = {};
      }
    } catch (e) {
      _favoriteIds = {};
    }
  }

  Future<void> toggleFavorite(int quoteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_favoriteIds.contains(quoteId)) {
        _favoriteIds.remove(quoteId);
      } else {
        _favoriteIds.add(quoteId);
      }
      
      await prefs.setString(
        _favoritesKey,
        _favoriteIds.join(','),
      );
    } catch (e) {
      // Handle error
    }
  }

  bool isFavorite(int quoteId) {
    return _favoriteIds.contains(quoteId);
  }

  Set<int> getFavoriteIds() {
    return _favoriteIds;
  }

  List<Quote> getFavoriteQuotes() {
    try {
      // Get all quotes from QuotesData
      final allQuotes = QuotesData.quotes;
      
      // Filter to get only favorite quotes
      return allQuotes.where((quote) => _favoriteIds.contains(quote.id)).toList();
    } catch (e) {
      return []; // Return empty list if there's an error
    }
  }

  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      _favoriteIds.clear();
    } catch (e) {
      // Handle error
    }
  }
}