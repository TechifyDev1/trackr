import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    final db = AuthService.instance.db;
    try {
      final doc = await db
          .collection("users")
          .doc(AuthService.instance.uid)
          .get();
      if (doc.exists) {
        state = User.fromMap(doc.data());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

final userProvider2 = StreamProvider.autoDispose<User>((ref) {
  final user = UserService.instance.watchUser();
  return user;
});
