import 'package:campus_mart/features/auth/repository/auth_repository.dart';
import 'package:riverpod/riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(authRepoService: ref.watch(authRepoProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepoService;
  AuthController({required this.authRepoService})
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
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
