import 'dart:developer';

import 'package:campus_mart/core/utils/providers.dart';
import 'package:campus_mart/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListProvider = Provider<ProductListRepository>((ref) {
  return ProductListRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class ProductListRepository {
 FirebaseFirestore firebaseFirestore;
 FirebaseAuth firebaseAuth;
 ProductListRepository(
  {required this.firebaseAuth, required this.firebaseFirestore}
 );

  Stream<List<Product>> fetchAllProducts(){
    try {
      if (firebaseAuth.currentUser == null) {
        return Stream.value([]);
      }
      final productDoc = firebaseFirestore.collection("products");
      return productDoc.snapshots().map((snaps) =>
          snaps.docs.map((doc) => Product.fromMap(doc.data())).toList());
    } on Exception catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  } 

}