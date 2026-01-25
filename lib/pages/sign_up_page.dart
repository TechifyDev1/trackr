import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_1/auth_gate.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';

abstract class AuthPage {}

class SignUpPage extends StatefulWidget implements AuthPage {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPassController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _confirmPassController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPassController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  bool _loading = false;

  String? _emailError;
  String? _nameError;
  String? _passwordError;
  bool _validate() {
    bool valid = true;

    if (_nameController.text.isEmpty) {
      _nameError = "Name is required";
      valid = false;
    } else {
      _nameError = null;
    }

    if (_emailController.text.isEmpty) {
      _emailError = "Email is required";
      valid = false;
    } else {
      _emailError = null;
    }

    if (_passwordController.text.isEmpty) {
      _passwordError = "Password is required";
      valid = false;
    } else if (_passwordController.text.trim() !=
        _confirmPassController.text.trim()) {
      _passwordError = "Password mismatch";
      valid = false;
    } else {
      _passwordError = null;
    }

    if (mounted) {
      setState(() {});
    }
    return valid;
  }

  void signUp(BuildContext context) async {
    if (_loading) return;
    if (!_validate()) return;
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    try {
      final res = await AuthService.instance.signUp(
        name: _nameController.text.trim(),
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
        Utils.showDialog(
          context: context,
          message: e.toString(),
          severity: Severity.high,
        );
      }
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  void signUpWithGoogle(BuildContext context) async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final res = await AuthService.instance.signUpWithGoogle();
      if (res["status"] == "error") {
        if (context.mounted) {
          Utils.showDialog(
            context: context,
            message: res["message"] ?? "Google sign-in failed",
            severity: Severity.high,
          );
        }
      }
      if (kDebugMode) print("Success Google sign up $res");
    } catch (e) {
      if (kDebugMode) print(e);
      if (context.mounted) {
        Utils.showDialog(
          context: context,
          message: e.toString(),
          severity: Severity.high,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // void _validateEmail() {}

  // void _validateName() {
  //   setState(() {});
  // }

  // void _validatePasswords() {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Trackr")),
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
                      "Welcome to Trackr",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Full name
                  const Text("Full Name", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _nameController,
                    placeholder: "John Doe",
                    errorText: _nameError,
                    onChanged: (value) {
                      if (_nameError != null) {
                        setState(() => _nameError = null);
                      }
                    },
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

                  // Confirm Password
                  const Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _confirmPassController,
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
                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        signUp(context);
                      },
                      color: CupertinoColors.extraLightBackgroundGray,
                      child: _loading
                          ? const CupertinoActivityIndicator(
                              radius: 10,
                              color: CupertinoColors.darkBackgroundGray,
                            )
                          : Text(
                              "Sign Up",
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
                        child: Text("Or Signup with"),
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
                      onPressed: () {
                        signUpWithGoogle(context);
                      },
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
                        text: "Already have an account?  ",
                        children: [
                          TextSpan(
                            text: "Login",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const AuthGate(
                                      destination: LoginPage(),
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
