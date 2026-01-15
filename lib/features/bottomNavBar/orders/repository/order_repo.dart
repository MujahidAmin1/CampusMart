import 'dart:developer';

import 'package:campusmart/core/providers.dart';
import 'package:campusmart/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class OrderRepository {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  OrderRepository({required this.firebaseAuth, required this.firebaseFirestore});

  Future<void> createOrder(Order order) async {
    try {
      await firebaseFirestore
          .collection("orders")
          .doc(order.orderId)
          .set(order.toMap());
    } on FirebaseException catch (e) {
      log(e.toString());
      throw (e.toString());
    }
  }

  Stream<List<Order>> fetchUserOrders(String userId) {
    return firebaseFirestore
        .collection('orders')
        .where('buyerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => Order.fromMap(doc.data()))
              .toList();
          // Sort in memory instead of using Firestore orderBy
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        })
        .handleError((error) {
          log('Error in fetchUserOrders: $error');
          throw error;
        });
  }

  Stream<List<Order>> fetchSellerOrders(String userId) {
    return firebaseFirestore
        .collection('orders')
        .where('sellerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => Order.fromMap(doc.data()))
              .toList();
          // Sort in memory instead of using Firestore orderBy
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        })
        .handleError((error) {
          log('Error in fetchSellerOrders: $error');
          throw error;
        });
  }

  Stream<Order?> fetchOrderById(String orderId, String userId) {
    return firebaseFirestore
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final order = Order.fromMap(snapshot.data()!);
        // Authorization check: only buyer or seller can access order details
        if (order.buyerId == userId || order.sellerId == userId) {
          return order;
        }
        log('Unauthorized access attempt to order $orderId by user $userId');
        return null;
      }
      return null;
    });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await firebaseFirestore.collection('orders').doc(orderId).update({
        'status': orderStatusToString(newStatus),
      });
    } on FirebaseException catch (e) {
      log(e.toString());
      throw (e.toString());
    }
  }

}