import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    state = prefs.getBool("loggedIn") ?? false;
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("loggedIn", true);

    state = true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("loggedIn", false);

    state = false;
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, bool>(
      (ref) => AuthNotifier(),
);