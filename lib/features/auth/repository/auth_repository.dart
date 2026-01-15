import 'package:campusmart/core/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user.dart';

final authRepoProvider = Provider((ref) {
  return AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
  );
});

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  
  AuthRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  Future<UserCredential?> createUser(String username, String email, String regNo, String password) async {
    final credentials = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credentials.user!;
    await user.updateDisplayName(username);
    try {
      final userDoc = firebaseFirestore.collection('users').doc(user.uid);
      await userDoc.set(User(
        username: username,
        email: email,
        id: user.uid,
        regNo: regNo,
      ).toMap());
      return credentials;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  //login
  Future<User?> login(String email, String password) async {
    try {
      final creds = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = creds.user!;

      final userDoc = await firebaseFirestore.collection('users').doc(user.uid).get();
      return User.fromMap(userDoc.data()!);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
