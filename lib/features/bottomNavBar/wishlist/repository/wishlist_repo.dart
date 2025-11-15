import 'package:campusmart/core/providers.dart';
import 'package:campusmart/models/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistRepo = Provider((ref) {
  return WishlistRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class WishlistRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  WishlistRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });
  Future<List<Wishlist>> fetchWishListByUserId(String userId) async {
    final wishDocs = await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .get();
    return wishDocs.docs.map((doc) => Wishlist.fromMap(doc.data())).toList();
  }

  Future addItemToWishList(Wishlist item) async {
    try {
      return firebaseFirestore
          .collection('users')
          .doc(item.userId)
          .collection('wishlist')
          .doc(item.wishlistId)
          .set(
            item.toMap(),
          );
    } catch (e) {
      throw (e.toString());
    }
  }

  Future removeFromWishList(Wishlist item) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(item.userId)
          .collection('wishlist')
          .doc(item.wishlistId)
          .delete();
    } catch (e) {
      throw (e.toString());
    }
  }
}
