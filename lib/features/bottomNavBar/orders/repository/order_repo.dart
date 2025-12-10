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
    try {
      log('Fetching orders for userId: $userId');
      return firebaseFirestore
          .collection('orders')
          .where('buyerId', isEqualTo: userId)
          // Temporarily removed orderBy to avoid composite index requirement
          // .orderBy('orderDate', descending: true)
          .snapshots()
          .handleError((error) {
            log('Error in fetchUserOrders stream: $error');
            log('Error type: ${error.runtimeType}');
            throw error;
          })
          .map((snapshot) {
            log('Received ${snapshot.docs.length} orders for buyer $userId');
            if (snapshot.docs.isEmpty) {
              log('No orders found. Check if orders exist in Firestore with buyerId: $userId');
            }
            final orders = snapshot.docs
                .map((doc) {
                  try {
                    log('Processing order doc: ${doc.id}');
                    final data = doc.data();
                    log('Order data: $data');
                    return Order.fromMap(data);
                  } catch (e) {
                    log('Error parsing order ${doc.id}: $e');
                    rethrow;
                  }
                })
                .toList();
            
            // Sort in memory instead of using Firestore orderBy
            orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
            
            return orders;
          });
    } catch (e) {
      log('Error setting up fetchUserOrders: $e');
      rethrow;
    }
  }

  Stream<List<Order>> fetchSellerOrders(String userId) {
    try {
      log('Fetching orders for sellerId: $userId');
      return firebaseFirestore
          .collection('orders')
          .where('sellerId', isEqualTo: userId)
          // Temporarily removed orderBy to avoid composite index requirement
          // .orderBy('orderDate', descending: true)
          .snapshots()
          .handleError((error) {
            log('Error in fetchSellerOrders stream: $error');
            log('Error type: ${error.runtimeType}');
            throw error;
          })
          .map((snapshot) {
            log('Received ${snapshot.docs.length} orders for seller $userId');
            if (snapshot.docs.isEmpty) {
              log('No orders found. Check if orders exist in Firestore with sellerId: $userId');
            }
            final orders = snapshot.docs
                .map((doc) {
                  try {
                    log('Processing seller order doc: ${doc.id}');
                    return Order.fromMap(doc.data());
                  } catch (e) {
                    log('Error parsing seller order ${doc.id}: $e');
                    rethrow;
                  }
                })
                .toList();
            
            // Sort in memory instead of using Firestore orderBy
            orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
            
            return orders;
          });
    } catch (e) {
      log('Error setting up fetchSellerOrders: $e');
      rethrow;
    }
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