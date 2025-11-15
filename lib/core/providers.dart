
import 'package:campusmart/core/cloudinary_img_upl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final authChangesProvider = StreamProvider((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService(
    cloudName: 'doy2uumie',
    apiKey: '114992431948494',
    apiSecret: 'zPUK12h_L9DBYOa0JCoF-eEhNcg',
  );
});
final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final isLoadingProvider = StateProvider((ref) {
  return false;
});
