import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class UserService {
  UserService._();
  final db = AuthService.instance.db;
  static final instance = UserService._();
  Stream<User> watchUser() {
    return db.collection("users").doc(AuthService.instance.uid).snapshots().map(
      (snapshot) {
        final data = snapshot.data();
        if (data == null) {
          throw Exception("User document does not exist");
        }
        return User.fromMap(data);
      },
    );
  }
}
