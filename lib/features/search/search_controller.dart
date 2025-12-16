import 'package:campusmart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:campusmart/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered search results
final searchResultsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final allProductsAsync = ref.watch(allProductsProvider);

  if (query.isEmpty) {
    return const AsyncValue.data([]);
  }

  return allProductsAsync.when(
    data: (products) {
      final filtered = products.where((product) {
        final titleMatch = product.title.toLowerCase().contains(query);
        final descriptionMatch = product.description.toLowerCase().contains(query);
        final categoryMatch = product.category.toLowerCase().contains(query);
        
        return titleMatch || descriptionMatch || categoryMatch;
      }).toList();
      
      return AsyncValue.data(filtered);
    },
    error: (e, st) => AsyncValue.error(e, st),
    loading: () => const AsyncValue.loading(),
  );
});
