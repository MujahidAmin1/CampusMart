import 'package:campusmart/features/auth/repository/auth_repository.dart';
import 'package:campusmart/features/bottomNavBar/notification/controller/notification_contr.dart';
import 'package:campusmart/features/bottomNavBar/orders/controller/order_contr.dart';
import 'package:riverpod/riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(authRepoService: ref.watch(authRepoProvider), ref: ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepoService;
  final Ref ref;
  
  AuthController({required this.authRepoService, required this.ref})
      : super(const AsyncValue.data(null));

  Future<void> register(
      String username, String email, String regNo, String password) async {
    state = const AsyncValue.loading();
    try {
      await authRepoService.createUser(
        username,
        email,
        regNo,
        password,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await authRepoService.login(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signout() async {
    state = const AsyncValue.loading();
    try {
      await authRepoService.logout();
      
      // Invalidate user-specific providers to clear cached data
      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadNotificationCountProvider);
      ref.invalidate(ordersProvider);
      ref.invalidate(sellerOrdersProvider);
      ref.invalidate(notificationControllerProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
