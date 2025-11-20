import 'package:campusmart/core/providers.dart';
import 'package:campusmart/features/bottomNavBar/wishlist/repository/wishlist_repo.dart';
import 'package:campusmart/models/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to get current user's wishlist with real-time updates
final wishlistProvider = StreamProvider<List<Wishlist>>((ref) {
  final wishlistRepository = ref.watch(wishlistRepo);
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  
  if (currentUser == null) {
    return Stream.value([]);
  }
  
  return wishlistRepository.streamWishListByUserId(currentUser.uid);
});

// StateNotifier for wishlist mutations (add/remove)
final wishlistControllerProvider = StateNotifierProvider<
    WishlistController, AsyncValue<List<Wishlist>>>((ref) {
  final wishlistRepository = ref.watch(wishlistRepo);
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  return WishlistController(
    wishlistRepository: wishlistRepository,
    userId: currentUser?.uid,
  );
});

class WishlistController extends StateNotifier<AsyncValue<List<Wishlist>>> {
  final WishlistRepository wishlistRepository;
  final String? userId;

  WishlistController({
    required this.wishlistRepository,
    required this.userId,
  }) : super(const AsyncValue.loading()) {
    if (userId != null) {
      fetchWishList();
    } else {
      state = const AsyncValue.data([]);
    }
  }

  /// Fetch all wishlist items for the logged-in user
  Future<void> fetchWishList() async {
    if (userId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final data = await wishlistRepository.fetchWishListByUserId(userId!);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Check if a product is already in wishlist
  bool isInWishlist(String productId) {
    final currentState = state;
    if (currentState is AsyncData<List<Wishlist>>) {
      return currentState.value.any((item) => item.productId == productId);
    }
    return false;
  }

  /// Get wishlist item by productId
  Wishlist? getWishlistItem(String productId) {
    final currentState = state;
    if (currentState is AsyncData<List<Wishlist>>) {
      try {
        return currentState.value.firstWhere(
          (item) => item.productId == productId,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Toggle: add or remove from wishlist
  Future<void> toggleWishlist(Wishlist item) async {
    final existingItem = getWishlistItem(item.productId);
    
    if (existingItem != null) {
      await removeFromWishList(existingItem);
    } else {
      await addItemToWishList(item);
    }
  }

  /// Add item with optimistic update
  Future<void> addItemToWishList(Wishlist item) async {
    final previousState = state;
    
    // Optimistic update
    final currentList = state.value ?? [];
    state = AsyncValue.data([...currentList, item]);
    
    try {
      final updated = await wishlistRepository.addItemToWishList(item);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      // Rollback on error
      state = previousState;
      rethrow;
    }
  }

  /// Remove item with optimistic update
  Future<void> removeFromWishList(Wishlist item) async {
    final previousState = state;
    
    // Optimistic update
    final currentList = state.value ?? [];
    final updated = currentList
        .where((w) => w.productId != item.productId)
        .toList();
    state = AsyncValue.data(updated);
    
    try {
      await wishlistRepository.removeFromWishList(item);
    } catch (e, st) {
      // Rollback on error
      state = previousState;
      rethrow;
    }
  }
}