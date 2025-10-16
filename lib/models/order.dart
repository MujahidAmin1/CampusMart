import 'package:campus_mart/models/cart_item.dart';
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
  delivered,
  cancelled,
  completed,
}

class Order {
  final String orderId;
  final String buyerId;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status; // pending, shipped, delivered, etc.
  final DateTime orderDate;
  final String deliveryAddress;
  final String? paymentId; // from gateway (e.g., Stripe)
  final bool isDeliveryConfirmed;
  final DateTime? deliveredAt;

  Order({
    required this.orderId,
    required this.buyerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    this.paymentId,
    this.isDeliveryConfirmed = false,
    this.deliveredAt,
  });
  Order copyWith({
    String? orderId,
    String? buyerId,
    List<CartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? orderDate,
    String? deliveryAddress,
    String? paymentId,
    bool? isDeliveryConfirmed,
    DateTime? deliveredAt,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      buyerId: buyerId ?? this.buyerId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentId: paymentId ?? this.paymentId,
      isDeliveryConfirmed: isDeliveryConfirmed ?? this.isDeliveryConfirmed,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      buyerId: map['buyerId'],
      items: (map['items'] as List)
          .map((e) => CartItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: orderStatusFromString(map['status']),
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      deliveryAddress: map['deliveryAddress'],
      paymentId: map['paymentId'],
      isDeliveryConfirmed: map['isDeliveryConfirmed'] ?? false,
      deliveredAt: map['deliveredAt'] != null
          ? (map['deliveredAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'buyerId': buyerId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': orderStatusToString(status),
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryAddress': deliveryAddress,
      'paymentId': paymentId,
      'isDeliveryConfirmed': isDeliveryConfirmed,
      'deliveredAt':
          deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
    };
  }
}
