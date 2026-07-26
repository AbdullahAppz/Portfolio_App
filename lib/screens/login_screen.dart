import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_auth.dart';
import '../widgets/custom_button.dart';
import '../widgets/success_snackbar.dart';
import 'navigation.dart';
import 'signup_screen.dart';
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRememberMe();
  }

  Future<void> loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    rememberMe = prefs.getBool("rememberMe") ?? false;

    if (rememberMe) {
      emailController.text =
          prefs.getString("savedEmail") ?? "";
    }

    setState(() {});
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuthService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();

      if (rememberMe) {
        await prefs.setBool("rememberMe", true);
        await prefs.setString(
            "savedEmail",
            emailController.text.trim());
      } else {
        await prefs.remove("rememberMe");
        await prefs.remove("savedEmail");
      }

      if (!mounted) return;

      SuccessSnackBar.show(
        context,
        "Login Successful",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text(
            e.message ??
                "Unable to login. Please try again.",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Please enter your email first."),
        ),
      );
      return;
    }
    try {
      await FirebaseAuthService.resetPassword(
        emailController.text.trim(),
      );
      if (!mounted) return;
      SuccessSnackBar.show(
        context,
        "Password reset email sent.",
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message ?? "Unable to send email.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Sign in to continue",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 35),

                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          TextFormField(
                            controller: emailController,
                            keyboardType:
                            TextInputType.emailAddress,
                            decoration:
                            const InputDecoration(
                              labelText: "Email",
                              prefixIcon:
                              Icon(Icons.email),
                              border:
                              OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return "Enter your email";
                              }

                              if (!value.contains("@")) {
                                return "Enter a valid email";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller:
                            passwordController,
                            obscureText:
                            obscurePassword,
                            decoration:
                            InputDecoration(
                              labelText: "Password",
                              prefixIcon:
                              const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility
                                      : Icons
                                      .visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword =
                                    !obscurePassword;
                                  });
                                },
                              ),
                              border:
                              const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.length < 6) {
                                return "Minimum 6 characters";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Checkbox(
                                activeColor:
                                Colors.green,
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe =
                                        value ?? false;
                                  });
                                },
                              ),
                              const Text(
                                "Remember Me",
                              ),
                            ],
                          ),

                          Align(
                            alignment:
                            Alignment.centerRight,
                            child: TextButton(
                              onPressed:
                              forgotPassword,
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.green,
                          )
                              : CustomButton(
                            text: "Login",
                            icon: Icons.login,
                            onPressed: login,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Portfolio Mobile Application",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}