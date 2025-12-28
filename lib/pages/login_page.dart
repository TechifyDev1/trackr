import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: const Text("Trackr")),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Text("Welcome Back!", style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 10),

              // Email
              const Text("Email", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              CustomTextInput(
                nameController: _emailController,
                placeholder: "johndoe@techify.com",
                prefixIcon: CupertinoIcons.mail,
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
              ),
              const SizedBox(height: 10),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  onPressed: () {},
                  color: CupertinoColors.extraLightBackgroundGray,
                  child: Text(
                    "Login",
                    style: TextStyle(color: CupertinoColors.darkBackgroundGray),
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
                  const Text("Or LogIn with"),
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
                            if (kDebugMode) {
                              print("Login clicked");
                            }
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
    );
  }
}
