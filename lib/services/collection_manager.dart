// lib/services/collection_manager.dart
import '../models/quote_model.dart';
import '../utils/favorite_manager.dart';

class CollectionManager {
  static final CollectionManager _instance = CollectionManager._internal();
  
  factory CollectionManager() {
    return _instance;
  }
  
  CollectionManager._internal();
  
  Future<void> addToCollection(Quote quote) async {
    await FavoriteManager().toggleFavorite(quote.id);
  }
  
  Future<void> removeFromCollection(int id) async {
    await FavoriteManager().toggleFavorite(id);
  }
  
  bool isInCollection(int id) {
    return FavoriteManager().isFavorite(id);
  }
  
  List<Quote> getFavorites() {
    return FavoriteManager().getFavoriteQuotes();
  }
  
  // Get favorites by category
  List<Quote> getFavoritesByCategory(String category) {
    return FavoriteManager().getFavoriteQuotes()
        .where((quote) => quote.category == category)
        .toList();
  }
  
  // Clear all favorites
  Future<void> clearAll() async {
    await FavoriteManager().clearAll();
  }
}