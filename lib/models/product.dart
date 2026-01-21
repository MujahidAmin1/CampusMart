import 'package:cloud_firestore/cloud_firestore.dart';

enum Category {
  all,
  electronics,
  fashion,
  furniture,
  academics,
  sports,
  gadgets,
  others,
}

class Product {
  final String productId;
  final String ownerId;
  final String title;
  final String description;
  final double price;
  final String category;
  final bool isAvailable;
  final bool isApproved;
  final DateTime datePosted;
  final List<String> imageUrls;

  Product({
    required this.productId,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.isAvailable,
    this.isApproved = false,
    required this.datePosted,
    required this.imageUrls,
  });

  Product copyWith({
    String? productId,
    String? ownerId,
    String? title,
    String? description,
    double? price,
    String? category,
    bool? isAvailable,
    bool? isApproved,
    DateTime? datePosted,
    List<String>? imageUrls,
  }) {
    return Product(
      productId: productId ?? this.productId,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      isApproved: isApproved ?? this.isApproved,
      datePosted: datePosted ?? this.datePosted,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['productId'],
      ownerId: map['ownerId'],
      title: map['title'],
      description: map['description'],
      price: map['price'].toDouble(),
      category: map['category'],
      isAvailable: map['isAvailable'],
      isApproved: map['isApproved'] ?? false,
      datePosted: (map['datePosted'] as Timestamp).toDate(),
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
      'isApproved': isApproved,
      'datePosted': datePosted,
      'imageUrls': imageUrls,
    };
  }
}
