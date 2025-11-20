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
}
