import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
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
      _db.collection("users").doc(credential.user?.uid.toString()).set({
        "name": name,
        "email": email,
      });
      if (kDebugMode) print(credential.user);
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

  void logout() {
    _auth.signOut();
  }

  Future<Map<String, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print("Login success: ${res.user?.uid}");
      }

      return {"status": "success", "message": "Login successful"};
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return {"status": "error", "message": "Invalid email address"};

        case "user-not-found":
          return {
            "status": "error",
            "message": "No account found with this email",
          };

        case "wrong-password":
          return {"status": "error", "message": "Incorrect password"};

        case "user-disabled":
          return {
            "status": "error",
            "message": "This account has been disabled",
          };

        case "network-request-failed":
          return {
            "status": "error",
            "message": "Check your internet connection",
          };

        case "too-many-requests":
          return {
            "status": "error",
            "message": "Too many attempts. Try again later",
          };

        default:
          return {
            "status": "error",
            "message": "Login failed. Please try again",
          };
      }
    } catch (e) {
      return {"status": "error", "message": "Unexpected error occurred"};
    }
  }
}
