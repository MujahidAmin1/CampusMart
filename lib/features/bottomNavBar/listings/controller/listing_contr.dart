import 'dart:developer';

import 'package:campusmart/core/providers.dart';
import 'package:campusmart/features/bottomNavBar/listings/repository/listing_repo.dart';
import 'package:campusmart/models/product.dart';
import 'package:campusmart/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryFilterProvider = StateProvider<Category>((ref) => Category.all);
final myProductListProvider = Provider<ProductListRepository>((ref) {
  return ProductListRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider), cloudinaryService: ref.watch(cloudinaryServiceProvider),
  );
});

final allProductsProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchAllProducts();
});
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final products = ref.watch(allProductsProvider);
  return products.when(
      data: (products) {
        var selectedCategory = ref.watch(categoryFilterProvider);
        final filtered = selectedCategory == Category.all
            ? products
            : products
                .where((p) => p.category == selectedCategory.name)
                .toList();
        return AsyncValue.data(filtered);
      },
      error: (e, st) => AsyncValue.error(e, st),
      loading: () => AsyncValue.loading());
});

// Provider to fetch product owner by ownerId
final productOwnerProvider = FutureProvider.family<User, String>((ref, ownerId) async {
  final repo = ref.watch(productRepositoryProvider);
  return await repo.fetchProductOwner(ownerId);
});

// Provider to fetch all products by owner
final ownerProductsProvider = FutureProvider.family<List<Product>, String>((ref, ownerId) async {
  final repo = ref.watch(productRepositoryProvider);
  return await repo.fetchProductsByOwner(ownerId);
});


class ProductListController extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductListRepository productRepo;
  final Ref ref;
  ProductListController(this.ref, {required this.productRepo})
      : super(AsyncValue.loading()) {
    fetchAllProducts();
  }

  void fetchAllProducts() async {
    try {
      ref.read(productRepositoryProvider).fetchAllProducts();
    } catch (e) {
      throw Exception(e);
    }
  }

  void createProduct(Product product) async {
    try {
      ref.read(productRepositoryProvider).createProduct(product);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void updateProduct(Product product) async {
    try {
      ref.read(productRepositoryProvider).updateProduct(product);
    } catch (e) {
      throw Exception(e);
    }
  }
}
