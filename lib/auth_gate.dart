import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/pages/sign_up_page.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/molecules/root_tabs.dart';

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
        final bool isAuthenticated = snapshot.data ?? false;

        // Get the destination type name
        final destinationType = destination.runtimeType.toString();

        // Define which pages are authentication pages (login/signup)
        final isAuthPage =
            destinationType == "LoginPage" || destinationType == "SignUpPage";

        // If user is authenticated AND trying to access auth pages, redirect to Home
        if (isAuthenticated && isAuthPage) {
          return RootTabs();
        }

        // If user is NOT authenticated AND trying to access protected pages, show auth
        if (!isAuthenticated && !isAuthPage) {
          return SignUpPage(); // or LoginPage()
        }

        // All other cases: return the requested destination
        return destination;
      },
    );
  }
}
