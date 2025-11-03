import 'dart:developer';

import 'package:campus_mart/core/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user.dart';

final authRepoProvider = Provider((ref){
  return AuthRepository(firebaseAuth: ref.watch(firebaseAuthProvider));
});
FirebaseFirestore _fire = FirebaseFirestore.instance;

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  AuthRepository({required this.firebaseAuth});
  //create
  Future<UserCredential?> createUser(
      String username, String email, String regNo, String password) async {
    final credentials =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credentials.user!;
    await user.updateDisplayName(username);
    try {
      final userDoc = _fire.collection('users').doc(user.uid);
      await userDoc.set(User(
        username: username,
        email: email,
        id: user.uid,
        regNo: regNo,
      ).toMap());
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
      log(user.toString());
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
  Future<void> logout()async{
    await firebaseAuth.signOut();
  }
}
