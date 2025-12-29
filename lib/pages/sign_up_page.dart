import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_1/auth_gate.dart';
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
        Utils.showError(context, e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
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
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .start,
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
                  nameController: _nameController,
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
                  nameController: _emailController,
                  placeholder: "johndoe@techify.com",
                  prefixIcon: CupertinoIcons.mail,
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
                  nameController: _passwordController,
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
                const Text("Confirm Password", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  nameController: _confirmPassController,
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
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      color: CupertinoColors.extraLightBackgroundGray,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("Or Signup with"),
                    const SizedBox(width: 5),
                    Container(
                      color: CupertinoColors.extraLightBackgroundGray,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        height: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Google Button
                Container(
                  color: CupertinoColors.darkBackgroundGray,
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: CupertinoColors.darkBackgroundGray,
                      onPressed: () {},
                      child: Row(
                        crossAxisAlignment: .center,
                        mainAxisAlignment: .center,
                        children: [
                          Image.asset(
                            "assets/logo/google_logo.png",
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            "oogle",
                            style: TextStyle(
                              color: CupertinoColors.extraLightBackgroundGray,
                              fontWeight: .w900,
                            ),
                          ),
                        ],
                      ),
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
                                  builder: (_) =>
                                      const AuthGate(destination: LoginPage()),
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
    );
  }
}
