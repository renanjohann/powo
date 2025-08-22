class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime createdAt;
  final List<String> following; // IDs dos restaurantes seguidos
  final List<String> followers; // IDs dos usuários seguidores

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.createdAt,
    this.following = const [],
    this.followers = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      following: List<String>.from(json['following'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'following': following,
      'followers': followers,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    DateTime? createdAt,
    List<String>? following,
    List<String>? followers,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
