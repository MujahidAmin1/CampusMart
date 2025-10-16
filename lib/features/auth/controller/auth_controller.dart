import 'package:campus_mart/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final authstateProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges(),
);

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepoService;
  final Ref _ref;
  AuthController(this._authRepoService, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> register(
      String username, String email, String regNo, String password) async {
    state = AsyncValue.loading();
    try {
      await _authRepoService.createUser(
        username,
        email,
        regNo,
        password,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String email, String password) async {
    state = AsyncValue.loading();
    try {
      await _authRepoService.login(email, password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  Future signout() async {
    state = AsyncValue.loading();
    try {
      await _authRepoService.logout();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
