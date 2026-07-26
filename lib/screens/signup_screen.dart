import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firebase_auth.dart';
import '../widgets/custom_button.dart';
import '../widgets/success_snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuthService.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      SuccessSnackBar.show(
        context,
        "Account Created Successfully!",
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text(
            e.message ?? "Unable to create account.",
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.person_add,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Create your new account",
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
                            controller: nameController,
                            decoration:
                            const InputDecoration(
                              labelText: "Full Name",
                              prefixIcon:
                              Icon(Icons.person),
                              border:
                              OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return "Enter your name";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller:
                            emailController,
                            keyboardType:
                            TextInputType
                                .emailAddress,
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
                                return "Enter email";
                              }

                              if (!value.contains("@")) {
                                return "Enter valid email";
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
                              const Icon(
                                  Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons
                                      .visibility
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

                          const SizedBox(height: 20),

                          TextFormField(
                            controller:
                            confirmPasswordController,
                            obscureText:
                            obscureConfirmPassword,
                            decoration:
                            InputDecoration(
                              labelText:
                              "Confirm Password",
                              prefixIcon:
                              const Icon(
                                  Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureConfirmPassword
                                      ? Icons
                                      .visibility
                                      : Icons
                                      .visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureConfirmPassword =
                                    !obscureConfirmPassword;
                                  });
                                },
                              ),
                              border:
                              const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value !=
                                  passwordController
                                      .text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25),

                          isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.green,
                          )
                              : CustomButton(
                            text: "Create Account",
                            icon:
                            Icons.person_add,
                            onPressed: signup,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Text(
                          "Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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