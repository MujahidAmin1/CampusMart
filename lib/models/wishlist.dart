import 'package:cloud_firestore/cloud_firestore.dart';

class Wishlist {
  String productTitle;
  String productId;
  String userId;
  String wishlistId;
  String sellerId;
  DateTime addedAt;
  double price;
  Wishlist({
    required this.productTitle,
    required this.userId,
    required this.productId,
    required this.sellerId,
    required this.wishlistId,
    required this.price,
    required this.addedAt,
  });
  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(
      productTitle: map['productTitle'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      wishlistId: map['wishlistId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      price: map['price'] ?? 0,
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'productTitle': productTitle,
      'userId': userId,
      'productId': productId,
      'price': price,
      'wishlistId': wishlistId,
      'sellerId': sellerId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
