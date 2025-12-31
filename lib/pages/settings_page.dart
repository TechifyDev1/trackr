import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _currPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailControler.dispose();
    _currPasswordController.dispose();
    _newPasswordController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Manage your account"),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    alignment: .center,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage(
                            "assets/images/qudus.png",
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextButton(onPressed: () {}, child: Text("Edit")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Text("Name", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _nameController,
                    placeholder: "John Doe",
                  ),
                  const SizedBox(height: 15),

                  const Text("Email", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _emailControler,
                    placeholder: "john@doe.com",
                    prefixIcon: CupertinoIcons.at,
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "Current password",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _currPasswordController,
                    placeholder: "******",
                    isPassWordInput: true,
                    prefixIcon: CupertinoIcons.padlock,
                  ),
                  const SizedBox(height: 15),

                  const Text("New password", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _newPasswordController,
                    isPassWordInput: true,
                    placeholder: "******",
                    prefixIcon: CupertinoIcons.padlock,
                  ),
                  const SizedBox(height: 15),

                  const Text("Currency", style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _currencyController,
                    placeholder: "Click to select your prefered currency",
                    prefixIcon: CupertinoIcons.money_euro_circle,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
