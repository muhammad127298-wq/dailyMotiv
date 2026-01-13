// lib/models/user_model.dart
class User {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}