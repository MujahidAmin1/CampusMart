import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/features/auth/controller/auth_controller.dart';
import 'package:campusmart/features/auth/widget/submitBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusmart/core/utils/ktextstyle.dart';

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
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final RegExp bukRegNoRegex =
      RegExp(r'^[A-Z]{3}\/(20|21|22|23|24|25|26)\/[A-Z]{3}\/\d{5}$');
  @override
  Widget build(BuildContext context) {
    final isSignup = ref.watch(isSignupProvider);
    final authstate = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString().replaceAll('Exception:', '').trim(),
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xff8E6CEF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff8E6CEF).withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                        child: Text("Welcome to CampusMart",
                            style: kTextStyle(
                                color: Color(0xff3A2770),
                                size: 26,
                                isBold: true))),
                    Center(
                        child: Text("Your Campus, Your Marketplace",
                            style: kTextStyle(
                                color: Color(0xff3A2770).withOpacity(0.6),
                                size: 16))),
                    const SizedBox(height: 30),
                    Center(
                        child: Text(
                            isSignup ? "Create Account" : "Welcome Back",
                            style: kTextStyle(
                                size: 28,
                                isBold: true,
                                color: Color(0xff3A2770)))),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 8,
                      shadowColor: Color(0xff8E6CEF).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Color(0xff6CEFBD).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          spacing: 18,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isSignup)
                              TextFormField(
                                controller: usernameController,
                                cursorColor: Color(0xff8E6CEF),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: Color(0xff8E6CEF)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Color(0xff8E6CEF), width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.red.shade300),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  hintText: "Username",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                              ),
                            if (isSignup)
                              TextFormField(
                                controller: regNoController,
                                cursorColor: Color(0xff8E6CEF),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.badge_outlined,
                                      color: Color(0xff8E6CEF)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Color(0xff8E6CEF), width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.red.shade300),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  hintText: "Registration Number",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Registration number is required';
                                  }
                                  final input = value.trim();
                                  if (!bukRegNoRegex.hasMatch(input)) {
                                    return 'Invalid registration number format';
                                  }
                                  return null;
                                },
                              ),
                            TextFormField(
                              controller: emailController,
                              cursorColor: Color(0xff8E6CEF),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: Color(0xff8E6CEF)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color(0xff8E6CEF), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade300),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                hintText: "Email",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
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
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              cursorColor: Color(0xff8E6CEF),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: Color(0xff8E6CEF)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color(0xff8E6CEF), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade300),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                hintText: "Password",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
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
                            buildSubmitButton(isSignup, authstate, () async {
                              if (_formKey.currentState!.validate()) {
                                final authcontroller =
                                    ref.read(authControllerProvider.notifier);
                                if (isSignup) {
                                  await authcontroller.register(
                                    usernameController.text.trim(),
                                    emailController.text.trim(),
                                    regNoController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                } else {
                                  await authcontroller.login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                }
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isSignup
                              ? "Already have an account? "
                              : "Don't have an account? ",
                          style: kTextStyle(
                              size: 14,
                              color: MyColors.darkBase.withOpacity(0.7)),
                        ),
                        GestureDetector(
                          onTap: () => toggleAuthStatus(ref, !isSignup),
                          child: Text(
                            isSignup ? "Sign In" : "Sign Up",
                            style: kTextStyle(size: 14).copyWith(
                              color: Color(0xff8E6CEF),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff8E6CEF),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
