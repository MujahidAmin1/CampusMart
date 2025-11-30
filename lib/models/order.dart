
import 'package:cloud_firestore/cloud_firestore.dart';


OrderStatus orderStatusFromString(String status) {
  return OrderStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => OrderStatus.pending,
  );
}

String orderStatusToString(OrderStatus status) => status.name;

enum OrderStatus {
  pending,
  processing,
  paid,
  shipped,
  collected,
  cancelled,
  completed,
}

class Order {
  final String orderId;
  final String productId;
  final String buyerId;
  final String sellerId;
  final double amount;
  final OrderStatus status; // pending, shipped, Recieved, etc.
  final DateTime orderDate;
  final String deliveryAddress;
  final String? paymentId;
   final bool isShippingConfirmed;
  final bool hasCollectedItem;
  final DateTime? recievedAt;

  Order({
    required this.orderId,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.amount,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    this.paymentId,
    this.isShippingConfirmed = false,
    this.hasCollectedItem = false,
    this.recievedAt,
  });
  Order copyWith({
    String? orderId,
    String? productId,
    String? buyerId,
    String? sellerId,
    double? totalAmount,
    OrderStatus? status,
    DateTime? orderDate,
    String? deliveryAddress,
    String? paymentId,
    bool? hasCollectedItem,
    bool? isShippingConfirmed,
    DateTime? recievedAt,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      buyerId: buyerId ?? this.buyerId,
      amount: amount ?? this.amount,
      sellerId: sellerId ?? this.sellerId,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentId: paymentId ?? this.paymentId,
      hasCollectedItem: hasCollectedItem ?? this.hasCollectedItem,
      recievedAt: recievedAt ?? this.recievedAt,
    );
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      productId: map['productId'] ?? '',
      buyerId: map['buyerId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      status: orderStatusFromString(map['status'] ?? 'pending'),
      orderDate: map['orderDate'] != null 
          ? (map['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      deliveryAddress: map['deliveryAddress'] ?? '',
      paymentId: map['paymentId'],
      isShippingConfirmed: map['isShippingConfirmed'] ?? false,
      hasCollectedItem: map['hasCollectedItem'] ?? false,
      recievedAt: map['recievedAt'] != null
          ? (map['recievedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'buyerId': buyerId,
      'amount': amount,
      'sellerId': sellerId,
      'status': orderStatusToString(status),
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryAddress': deliveryAddress,
      'paymentId': paymentId,
      'isShippingConfirmed': isShippingConfirmed,
      'hasCollectedItem': hasCollectedItem,
      'recievedAt':
          recievedAt != null ? Timestamp.fromDate(recievedAt!) : null,
    };
  }
}
