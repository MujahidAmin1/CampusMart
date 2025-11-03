import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final authChangesProvider = StreamProvider((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final appwriteClientProvider = Provider(
  (ref) {
    final client = Client()
        .setEndpoint('https://fra.cloud.appwrite.io/v1')
        .setProject('68f8a26b001714973226');
    return client;
  },
);
final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});
final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final isLoadingProvider = StateProvider((ref) {
  return false;
});
