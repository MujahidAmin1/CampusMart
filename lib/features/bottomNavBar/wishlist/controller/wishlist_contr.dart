import 'package:campusmart/core/providers.dart';
import 'package:campusmart/features/bottomNavBar/wishlist/repository/wishlist_repo.dart';
import 'package:campusmart/models/wishlist.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishContProvider =
    StateNotifierProvider<WishlistController, AsyncValue<List<Wishlist>>>(
        (ref) {
  return WishlistController(wishlistRepository: ref.watch(wishlistRepo));
});

class WishlistController extends StateNotifier<AsyncValue<List<Wishlist>>> {
  final WishlistRepository wishlistRepository;

  WishlistController({required this.wishlistRepository})
      : super(const AsyncValue.loading()) {
    fetchWishList();
  }

  Future<void> fetchWishList() async {
    var authUser = wishlistRepository.firebaseAuth.currentUser!;
    state = AsyncValue.loading();
    try {
      final data = await wishlistRepository.fetchWishListByUserId(authUser.uid);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future addItemToWishList(Wishlist item) async {
    state = AsyncValue.loading();
    try {
      final data = await wishlistRepository.addItemToWishList(item);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
