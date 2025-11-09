import 'package:campusmart/core/loading_screen.dart';
import 'package:campusmart/core/providers.dart';
import 'package:campusmart/features/auth/controller/auth_controller.dart';
import 'package:campusmart/features/auth/view/authscreen.dart';
import 'package:campusmart/features/bottomNavBar/home/homeview.dart';
import 'package:campusmart/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: const MainApp(),
    ),
  );
}


class MainApp extends ConsumerWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   var currentUser = ref.watch(authChangesProvider); // Use this instead
return MaterialApp(
  home: currentUser.when(
    data: (firebaseUser) => firebaseUser != null ? BottomBarC() : AuthScreen(), 
    error: (_, __) => AuthScreen(), 
    loading: () => Scaffold(
      body: Center(
        child: SpinKitSpinningLines(color: Colors.black)
      )
    ),
  ),);
  }
}
