import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseAuthService {

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // Login
  static Future<User?> login(
      String email,
      String password) async {

    final credential =
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }
// Signup
  static Future<User?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user!.updateDisplayName(name);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(credential.user!.uid)
        .set({
      "uid": credential.user!.uid,
      "name": name,
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
    });

    return credential.user;
  }
  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset Password
  static Future<void> resetPassword(
      String email) async {

    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  // Current User
  static User? get currentUser =>
      _auth.currentUser;
}