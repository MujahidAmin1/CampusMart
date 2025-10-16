import 'package:campus_mart/features/auth/controller/auth_controller.dart';
import 'package:campus_mart/features/auth/view/authscreen.dart';
import 'package:campus_mart/firebase_options.dart';
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
    var currentUser = ref.watch(authstateProvider);
    return MaterialApp(
      home: currentUser.when(
        data: data, 
        error: (_, __) => Authscreen() , 
        loading: ()=> SpinKitSpinningLines(color: Colors.black),
        ),
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
