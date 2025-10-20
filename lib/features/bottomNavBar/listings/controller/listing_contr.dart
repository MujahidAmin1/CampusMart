
import 'package:campus_mart/features/bottomNavBar/listings/repository/listing_repo.dart';
import 'package:campus_mart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final categoryFilterProvider = StateProvider<Category>((ref) => Category.all);

final allProductsProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productListProvider);
  return repo.fetchAllProducts();
});
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref){
  final products = ref.watch(allProductsProvider);
  final filter = ref.watch(categoryFilterProvider);
  return products.when(
    data: (products){
      var selectedCategory = ref.watch(categoryFilterProvider);
      final filtered = selectedCategory == Category.all ? products : products.where((p)=> p.category == selectedCategory.name).toList();
      return AsyncValue.data(filtered);
  }, error: (e, st) => AsyncValue.error(e, st), loading: () => AsyncValue.loading());
});



class ProductListController extends StateNotifier<AsyncValue<List<Product>>>{
  final Ref ref;
  ProductListController(this.ref) : super(AsyncValue.loading()){
    fetchAllProducts();
  }
  void fetchAllProducts() async{
    try {
  ref.read(productListProvider).fetchAllProducts();
} catch (e) {
  throw Exception(e);
}

  }
 }