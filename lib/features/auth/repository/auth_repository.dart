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
    try {
      final credentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credentials.user!;
      await user.updateDisplayName(username);
      
      final userDoc = firebaseFirestore.collection('users').doc(user.uid);
      await userDoc.set(User(
        username: username,
        email: email,
        id: user.uid,
        regNo: regNo,
      ).toMap());
      return credentials;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    } on Exception catch (e) {
      throw Exception(e.toString());
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
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
