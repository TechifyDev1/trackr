import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/sign_up_page.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class AuthGate extends StatelessWidget {
  final Widget destination;
  const AuthGate({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final Stream<bool> signedIn = AuthService.instance.isAuthenticated();
    return StreamBuilder(
      stream: signedIn,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return destination;
        }
        if ((destination.runtimeType.toString() == "SignUpPage" &&
                snapshot.data == true) ||
            (destination.runtimeType.toString() == "LoginPage" &&
                snapshot.data == true)) {
          return HomePage();
        }
        return SignUpPage();
      },
    );
  }
}
