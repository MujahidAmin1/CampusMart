
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
  Recieved,
  cancelled,
  completed,
}

class Order {
  final String orderId;
  final String buyerId;
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
    required this.buyerId,
    // required this.items,
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
    String? buyerId,
    // List<CartItem>? items,
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
      buyerId: buyerId ?? this.buyerId,
      amount: amount ?? this.amount,
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
      orderId: map['orderId'],
      buyerId: map['buyerId'],
      amount: (map['amount'] as num).toDouble(),
      status: orderStatusFromString(map['status']),
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      deliveryAddress: map['deliveryAddress'],
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
      'buyerId': buyerId,
      'totalAmount': amount,
      'status': orderStatusToString(status),
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryAddress': deliveryAddress,
      'paymentId': paymentId,
      'hasCollectedItem': hasCollectedItem,
      'recievedAt':
          recievedAt != null ? Timestamp.fromDate(recievedAt!) : null,
    };
  }
}
