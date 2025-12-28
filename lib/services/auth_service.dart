import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser() => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();
  Stream<bool> isAuthenticated() {
    return authStateChanges().map((user) => user != null);
  }

  Future<Map<String, String>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (kDebugMode) print(credential);
      return {"status": "success", "message": "Account created Successfully"};
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw "Password is too weak";
      } else if (e.code == "email-already-in-use") {
        throw "Email already in use";
      }
    } catch (e) {
      throw "Unexpected error occured $e";
    }
    throw "Unexpected error occured";
  }
}
