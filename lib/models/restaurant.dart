class Restaurant {
  final String id;
  final String name;
  final String address;
  final String contact;
  final String? image;
  final double averageRating;
  final int totalReviews;
  final List<Product> products;
  final DateTime createdAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    this.image,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.products = const [],
    required this.createdAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      contact: json['contact'],
      image: json['image'],
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      products: (json['products'] as List<dynamic>?)
          ?.map((product) => Product.fromJson(product))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contact': contact,
      'image': image,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'products': products.map((product) => product.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? address,
    String? contact,
    String? image,
    double? averageRating,
    int? totalReviews,
    List<Product>? products,
    DateTime? createdAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      image: image ?? this.image,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? image;
  final double averageRating;
  final int totalReviews;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'],
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    double? averageRating,
    int? totalReviews,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}
