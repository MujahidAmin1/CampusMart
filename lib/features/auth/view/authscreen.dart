import 'package:campus_mart/features/auth/controller/auth_controller.dart';
import 'package:campus_mart/features/auth/widget/submitBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_mart/core/utils/ktextstyle.dart';

final isSignupProvider = StateProvider<bool>(
  (ref) => true,
);
void toggleAuthStatus(WidgetRef ref, bool val) {
  ref.read(isSignupProvider.notifier).state = val;
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController regNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    final isSignup = ref.watch(isSignupProvider);
    final authstate = ref.watch(authControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                    child: Text(isSignup ? "Sign Up" : "Login",
                        style: kTextStyle(size: 40))),
                const SizedBox(height: 20),
                if (isSignup)
                  TextFormField(
                    controller: usernameController,
                    cursorColor: Color(0xff8E6CEF),
                    decoration: InputDecoration(
                      focusColor: Color(0xff8E6CEF),
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),
                if (isSignup)
                  TextFormField(
                    controller: regNoController,
                    cursorColor: Color(0xff8E6CEF),
                    decoration: InputDecoration(
                      focusColor: Color(0xff8E6CEF),
                      hintText: "Registration Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  cursorColor: Color(0xff8E6CEF),
                  decoration: InputDecoration(
                    focusColor: Color(0xff8E6CEF),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  cursorColor: Color(0xff8E6CEF),
                  decoration: InputDecoration(
                    focusColor: Color(0xff8E6CEF),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildSubmitButton(isSignup, authstate, () {
                  if (_formKey.currentState!.validate()) {
                    final authcontroller =
                        ref.read(authControllerProvider.notifier);
                    if (isSignup) {
                      authcontroller.register(
                        usernameController.text.trim(),
                        emailController.text.trim(),
                        regNoController.text.trim(),
                        passwordController.text.trim(),
                      );
                    } else {
                      authcontroller.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    }
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
