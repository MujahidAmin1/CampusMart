import 'package:campusmart/features/bottomNavBar/listings/repository/listing_repo.dart';
import 'package:campusmart/models/product.dart';
import 'package:campusmart/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryFilterProvider = StateProvider<Category>((ref) => Category.all);
final priceRangeFilterProvider = StateProvider<RangeValues>((ref) => const RangeValues(0, 500000));

final allProductsProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchAllProducts();
});

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final products = ref.watch(allProductsProvider);
  return products.when(
      data: (products) {
        var selectedCategory = ref.watch(categoryFilterProvider);
        var priceRange = ref.watch(priceRangeFilterProvider);
        
        final filtered = products.where((p) {
          final matchesCategory = selectedCategory == Category.all || 
              p.category == selectedCategory.name;
          final matchesPrice = p.price >= priceRange.start && 
              p.price <= priceRange.end;
          return matchesCategory && matchesPrice;
        }).toList();
        
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

