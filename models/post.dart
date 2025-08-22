class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String? authorType; // 'user' ou 'restaurant'
  final String? restaurantId;
  final String? productId;
  final String? productName;
  final String? restaurantName;
  final double rating;
  final String? comment;
  final String? image;
  final List<String> likes;
  final List<Comment> comments;
  final DateTime createdAt;
  final bool isPublic; // Se deve aparecer no feed público

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    this.authorType,
    this.restaurantId,
    this.productId,
    this.productName,
    this.restaurantName,
    required this.rating,
    this.comment,
    this.image,
    this.likes = const [],
    this.comments = const [],
    required this.createdAt,
    this.isPublic = true,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      authorType: json['authorType'],
      restaurantId: json['restaurantId'],
      productId: json['productId'],
      productName: json['productName'],
      restaurantName: json['restaurantName'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'],
      image: json['image'],
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromJson(comment))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      isPublic: json['isPublic'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'authorType': authorType,
      'restaurantId': restaurantId,
      'productId': productId,
      'productName': productName,
      'restaurantName': restaurantName,
      'rating': rating,
      'comment': comment,
      'image': image,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isPublic': isPublic,
    };
  }

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorImage,
    String? authorType,
    String? restaurantId,
    String? productId,
    String? productName,
    String? restaurantName,
    double? rating,
    String? comment,
    String? image,
    List<String>? likes,
    List<Comment>? comments,
    DateTime? createdAt,
    bool? isPublic,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      authorType: authorType ?? this.authorType,
      restaurantId: restaurantId ?? this.restaurantId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      restaurantName: restaurantName ?? this.restaurantName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}

class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
