import 'package:campusmart/features/bottomNavBar/profile/repository/profile_repo.dart';
import 'package:campusmart/models/product.dart';
import 'package:campusmart/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileContProvider = FutureProvider.family<User, String>((ref, userId) async {
  final profileRepo = ref.watch(profileProvider);
  return await profileRepo.fetchUserById(userId);
});

final myListingsProvider = FutureProvider<List<Product>>((ref) async {
  ref.keepAlive(); // Prevents auto-disposal on auth change
  final profileRepo = ref.watch(profileProvider);
  return await profileRepo.getProductsListedByMe();
});

class ProfileController extends StateNotifier<AsyncValue<User>> {
  final ProfileRepository profileRepository;
  ProfileController({required this.profileRepository})
      : super(
          AsyncValue.loading(),
        );

  Future<void> fetchUserById(String userId) async {
    state = const AsyncValue.loading();

    try {
      final user = await profileRepository.fetchUserById(userId);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  Future<List<Product>> getProductsListedByMe()async{
    return await profileRepository.getProductsListedByMe();
  }
}
