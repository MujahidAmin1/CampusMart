import 'dart:developer';

import 'package:campus_mart/core/providers.dart';
import 'package:campus_mart/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = Provider<OrderRepo>((ref) {
  return OrderRepo(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class OrderRepo {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  OrderRepo({required this.firebaseAuth, required this.firebaseFirestore});

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
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Order.fromMap(doc.data()))
          .toList());
}


}
