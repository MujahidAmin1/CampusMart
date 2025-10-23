import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:campus_mart/core/utils/appwrite_img_upl.dart';
import 'package:campus_mart/core/utils/bucket_ids.dart';
import 'package:campus_mart/core/utils/providers.dart';
import 'package:campus_mart/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListProvider = Provider<ProductListRepository>((ref) {
  return ProductListRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
    storage: ref.watch(appwriteStorageProvider),
  );
});

class ProductListRepository {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  Storage storage;
  ProductListRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.storage,
  });

  Stream<List<Product>> fetchAllProducts() {
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

  Future<void> createProduct(Product productListing) async {
    try {
      List<String> urls = await Future.wait(
        productListing.imageUrls.map(
          (url) async {
            return await uploadImage(
                storage, File(url), ImageBucketIDs.listings);
          },
        ),
      );

      Product newProduct = productListing.copyWith(imageUrls: urls);
      await firebaseFirestore
          .collection("products")
          .doc(newProduct.productId)
          .set(newProduct.toMap());
    } on (FirebaseException, AppwriteException) catch (e) {
      log(e.toString());
      throw Exception("Error creating product listing");
    }
  }
}
