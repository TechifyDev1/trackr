import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
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
      db.collection("users").doc(credential.user?.uid.toString()).set({
        "name": name,
        "email": email,
        "currency": Currencies.ngn.name,
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
        case "invalid-credential":
        case "invalid-email":
          throw {
            "status": "error",
            "message": "Invalid email address or password",
          };

        case "user-not-found":
          throw {
            "status": "error",
            "message": "No account found with this email",
          };

        case "wrong-password":
          throw {"status": "error", "message": "Incorrect password"};

        case "user-disabled":
          throw {
            "status": "error",
            "message": "This account has been disabled",
          };

        case "network-request-failed":
          throw {
            "status": "error",
            "message": "Check your internet connection",
          };

        case "too-many-requests":
          throw {
            "status": "error",
            "message": "Too many attempts. Try again later",
          };

        default:
          throw {
            "status": "error",
            "message": "Login failed. Please try again",
          };
      }
    } catch (e) {
      throw {"status": "error", "message": "Unexpected error occurred"};
    }
  }

  String? get uid => _auth.currentUser?.uid;
  Future<Map<String, String>> signUpWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Obtain Google authentication tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        // Failed to get ID token
        return {
          "status": "error",
          "message": "Failed to obtain Google ID token",
        };
      }

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user == null) {
        return {"status": "error", "message": "Failed to sign in with Google"};
      }

      // Update or create Firestore profile atomically
      final userDoc = db.collection("users").doc(user.uid);

      if (kDebugMode) {
        print("Syncing Firestore for user: ${user.uid}");
      }

      // Initial data set with merge to preserve fields like 'currency' if they exist,
      // but ensure essential fields are populated.
      await userDoc.set({
        "name": googleUser.displayName ?? user.displayName ?? "Trackr User",
        "email": googleUser.email,
        "photoUrl": googleUser.photoUrl ?? user.photoURL ?? "",
        "provider": "google",
        "lastUpdated": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Second check: Ensure currency exists (only update if null)
      final profileSnap = await userDoc.get();
      if (profileSnap.data()?["currency"] == null) {
        await userDoc.update({
          "currency": Currencies.ngn.name,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      if (kDebugMode) {
        print("Firestore sync complete for ${user.email}");
      }

      return {
        "status": "success",
        "message": "Signed in with Google successfully",
      };
    } on FirebaseAuthException catch (e) {
      // Firebase-specific errors
      return {
        "status": "error",
        "message": e.message ?? "Google sign-in failed",
      };
    } catch (e, st) {
      // Catch all unexpected errors
      if (kDebugMode) {
        print("Error in signUpWithGoogle: $e\n$st");
      }
      return {
        "status": "error",
        "message": "An unexpected error occurred during Google sign-in",
      };
    }
  }
}
