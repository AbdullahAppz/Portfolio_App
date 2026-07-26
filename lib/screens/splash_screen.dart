import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'navigation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    navigate();
  }

  Future<void> navigate() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    final loggedIn = ref.read(authProvider);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
        loggedIn
            ? const MainNavigation()
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [
              Color(0xff0f9d58),
              Color(0xff34a853),
            ],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

          ),
        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 30),

            const Text(

              "Portfolio App",

              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(

              "Production Ready Portfolio",

              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 45),

            const CircularProgressIndicator(
              color: Colors.white,
            ),

            const SizedBox(height: 25),

            const Text(

              "Loading...",

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

          ],
        ),
      ),
    );
  }
}