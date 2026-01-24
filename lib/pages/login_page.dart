import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_1/auth_gate.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/pages/sign_up_page.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';

class LoginPage extends StatefulWidget implements AuthPage {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _emailError;
  String? _passwordError;

  bool _validate() {
    bool valid = true;

    if (_emailController.text.isEmpty) {
      _emailError = "Email is required";
      valid = false;
    } else {
      _emailError = null;
    }

    if (_passwordController.text.isEmpty) {
      _passwordError = "Password is required";
      valid = false;
    }
    if (mounted) {
      setState(() {});
    }
    return valid;
  }

  void login(BuildContext context) async {
    if (_loading) return;
    if (!_validate()) return;
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final res = await AuthService.instance.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (kDebugMode) print("Success signing up $res");
      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) print(e);
      if (context.mounted) {
        final errData = e as Map<String, dynamic>;
        Utils.showDialog(
          context: context,
          message: errData["message"].toDetailedString(),
          severity: Severity.high,
        );
      }
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: const Text("Trackr")),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "Welcome Back!",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Email
                  const Text("Email", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _emailController,
                    placeholder: "johndoe@techify.com",
                    prefixIcon: CupertinoIcons.at,
                    errorText: _emailError,
                    onChanged: (value) {
                      if (_emailError != null) {
                        setState(() => _emailError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password
                  const Text("Password", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _passwordController,
                    placeholder: "********",
                    isPassWordInput: true,
                    prefixIcon: CupertinoIcons.padlock,
                    errorText: _passwordError,
                    onChanged: (value) {
                      if (_passwordError != null) {
                        setState(() => _passwordError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        login(context);
                      },
                      color: CupertinoColors.extraLightBackgroundGray,
                      child: _loading
                          ? const CupertinoActivityIndicator(
                              radius: 10,
                              color: CupertinoColors.darkBackgroundGray,
                            )
                          : Text(
                              "Log in",
                              style: TextStyle(
                                color: CupertinoColors.darkBackgroundGray,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Or LogIn with"),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: CupertinoColors.extraLightBackgroundGray,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Google Button
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: CupertinoColors.darkBackgroundGray,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/logo/google_logo.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Google",
                            style: TextStyle(
                              color: CupertinoColors.extraLightBackgroundGray,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account?  ",
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const AuthGate(
                                      destination: SignUpPage(),
                                    ),
                                  ),
                                );
                              },
                            style: TextStyle(decoration: .underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
