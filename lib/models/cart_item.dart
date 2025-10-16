import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String productTitle;
  String productId;
  String userId;
  int quantity;
  String cartItemId;
  String sellerId;
  DateTime addedAt;
  double price;
  CartItem({
    required this.productTitle,
    required this.userId,
    required this.productId,
    required this.sellerId,
    required this.cartItemId,
    required this.quantity,
    required this.price,
    required this.addedAt,
  });
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productTitle: map['productTitle'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      cartItemId: map['cartItemId'] ?? '',
      quantity: map['quantity'] ?? 1,
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
      'cartItemId': cartItemId,
      'quantity': quantity,
      'sellerId': sellerId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
