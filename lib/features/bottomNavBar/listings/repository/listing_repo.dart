import 'dart:developer';
import 'dart:io';

import 'package:campusmart/core/cloudinary_img_upl.dart';
import 'package:campusmart/core/providers.dart';
import 'package:campusmart/models/product.dart';
import 'package:campusmart/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductListRepository>((ref) {
  return ProductListRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
    cloudinaryService: ref.watch(cloudinaryServiceProvider),
  );
});

class ProductListRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final CloudinaryService cloudinaryService;

  ProductListRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.cloudinaryService,
  
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
      // Upload all images to Cloudinary (same as before!)
      List<String> urls = await Future.wait(
        productListing.imageUrls.map((path) async {
          return await cloudinaryService.uploadImage(File(path));
        }),
      );

      // Create new product with Cloudinary URLs
      Product newProduct = productListing.copyWith(imageUrls: urls);
      
      await firebaseFirestore
          .collection("products")
          .doc(newProduct.productId)
          .set(newProduct.toMap());
          
    } on FirebaseException catch (e) {
      log(e.toString());
      throw Exception("Error creating product listing");
    } catch (e) {
      log(e.toString());
      throw Exception("Error creating product listing");
    }
  }

  Future updateProduct(Product product) async {
    final updatedProd = product.copyWith(
      productId: product.productId,
      ownerId: product.ownerId,
      title: product.title,
      description: product.description,
      price: product.price,
      category: product.category,
      isAvailable: product.isAvailable,
      datePosted: product.datePosted,
      imageUrls: product.imageUrls,
    );
    final productDoc = FirebaseFirestore.instance
        .collection("products")
        .doc(product.productId);
    await productDoc.update(updatedProd.toMap());
  }

  Future deleteProduct(Product product) async {
    final productDoc = FirebaseFirestore.instance
        .collection("products")
        .doc(product.productId);
    await productDoc.delete();
  }

  Future<User> fetchProductOwner(String ownerId) async {
    try {
      final userDoc = await firebaseFirestore
          .collection('users')
          .doc(ownerId)
          .get();
      
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      
      return User.fromMap(userDoc.data()!);
    } catch (e) {
      log('Error fetching product owner: $e');
      throw Exception('Failed to fetch owner information');
    }
  }

  Future<List<Product>> fetchProductsByOwner(String ownerId) async {
    try {
      final productsSnapshot = await firebaseFirestore
          .collection('products')
          .where('ownerId', isEqualTo: ownerId)
          .get();
      
      return productsSnapshot.docs
          .map((doc) => Product.fromMap(doc.data()))
          .toList();
    } catch (e) {
      log('Error fetching products by owner: $e');
      throw Exception('Failed to fetch owner products');
    }
  }
}