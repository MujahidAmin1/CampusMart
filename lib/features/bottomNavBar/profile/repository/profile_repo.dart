import 'dart:developer';

import 'package:campusmart/core/providers.dart';
import 'package:campusmart/models/product.dart';
import 'package:campusmart/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = Provider((ref) {
  return ProfileRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class ProfileRepository {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  ProfileRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  Future<User> fetchUserById(String id) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(id).get();
      return User.fromMap(userDoc.data()!);
    } on Exception catch (e) {
      throw (e.toString());
    }
  }

  Future<List<Product>> getProductsListedByMe() async {
    final currentUser = firebaseAuth.currentUser;

    final userDoc = await firebaseFirestore
        .collection('products')
        .where('ownerId', isEqualTo: currentUser?.uid)
        .get();
    return userDoc.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }
  /// Fetches a stream of products from orders where:
  /// - sellerId matches the provided uid
  /// - status is 'paid'
  Stream<List<Product>> itemsPaidFor(String uid) async* {
    // Query orders collection for paid orders belonging to this seller
    final ordersStream = firebaseFirestore
        .collection('orders')
        .where('sellerId', isEqualTo: uid)
        .where('status', isEqualTo: 'paid')
        .snapshots();

    // For each snapshot of orders, fetch the corresponding products
    await for (final orderSnapshot in ordersStream) {
      final List<Product> products = [];
      
      // Extract productIds from orders
      for (final orderDoc in orderSnapshot.docs) {
        try {
          final orderData = orderDoc.data();
          final productId = orderData['productId'] as String?;
          
          if (productId != null) {
            // Fetch the actual product document
            final productDoc = await firebaseFirestore
                .collection('products')
                .doc(productId)
                .get();
            
            if (productDoc.exists && productDoc.data() != null) {
              products.add(Product.fromMap(productDoc.data()!));
            }
          }
        } catch (e) {
          log('Error fetching product for order ${orderDoc.id}: $e');
          // Continue processing other orders even if one fails
        }
      }
      
      yield products;
    }
  }
  Future deleteProduct(String productId) async {
    try {
      await firebaseFirestore.collection('products').doc(productId).delete();
    } catch (e) {
      log('Error deleting product $productId: $e');
      throw e;
    }
  }
}
