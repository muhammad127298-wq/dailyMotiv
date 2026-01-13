// lib/models/quote_model.dart
class Quote {
  final int id;
  final String text;
  final String colorScheme;
  final String category;

  Quote({
    required this.id,
    required this.text,
    required this.colorScheme,
    required this.category,
  });

  // Getter to check if quote is favorite
  bool get isFavorite {
    // We'll implement this properly in the FavoriteManager
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'colorScheme': colorScheme,
      'category': category,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] ?? 0,
      text: map['text'] ?? '',
      colorScheme: map['colorScheme'] ?? 'teal',
      category: map['category'] ?? 'success',
    );
  }
}