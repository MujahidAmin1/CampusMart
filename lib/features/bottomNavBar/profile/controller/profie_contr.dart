import 'dart:io';
import 'package:campusmart/features/bottomNavBar/profile/repository/profile_repo.dart';
import 'package:campusmart/models/product.dart';
import 'package:campusmart/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileContProvider = Provider((ref) async {
  return ProfileController(
    profileRepository: ref.watch(profileProvider),
  );
});

final myListingsProvider = FutureProvider<List<Product>>((ref) async {
  ref.keepAlive(); // Prevents auto-disposal on auth change
  final profileRepo = ref.watch(profileProvider);
  return await profileRepo.getProductsListedByMe();
});


final userByIdProvider = StreamProvider.family<User?, String>((ref, userId) {
  final repo = ref.watch(profileProvider);
  return repo.streamUserById(userId);
});

// Provider to fetch products listed by current user
final myListedProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(profileProvider);
  return await repo.getProductsListedByMe();
});

// StreamProvider for items paid for by user
final itemsPaidForProvider = StreamProvider.family<List<Product>, String>((ref, uid) {
  final repo = ref.watch(profileProvider);
  return repo.itemsPaidFor(uid);
});

final deleteProductProvider = FutureProvider.family<void, String>((ref, productId) async {
  final repo = ref.watch(profileProvider);
  await repo.deleteProduct(productId);
});

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<User?>>((ref) {
  return ProfileController(
    profileRepository: ref.watch(profileProvider),
  );
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
  Stream<List<Product>> itemsPaidFor(String uid){
    return profileRepository.itemsPaidFor(uid);
  }
  Future<void> updateProduct(Product product) async {
    await profileRepository.updateProduct(product);
  }
  Future deleteProduct(String productId) async {
    await profileRepository.deleteProduct(productId);
  }

  Future<void> updateProfile({required String username, File? imageFile}) async {
    await profileRepository.updateProfile(username: username, imageFile: imageFile);
  }
}
