import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/utils.dart';
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

  final List<Currencies> _currencies = Currencies.values;
  int _selectedCurrency = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailControler.dispose();
    _currPasswordController.dispose();
    _newPasswordController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  void _showCurrenciesPopup(Widget picker) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 260,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text("Done"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(child: picker),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Manage your account"),
        trailing: IconButton(
          onPressed: () {
            Utils.showConfirmationDialog(
              context,
              message: "Are you sure you want logout?",
              severity: Severity.medium,
              action: AuthService.instance.logout,
            );
            ;
          },
          icon: Icon(
            CupertinoIcons.square_arrow_right,
            color: CupertinoColors.destructiveRed,
          ),
        ),
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
                  GestureDetector(
                    onTap: () {
                      _showCurrenciesPopup(
                        CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int selectedCurrency) {
                            setState(() {
                              _selectedCurrency = selectedCurrency;
                              _currencyController.text =
                                  _currencies[selectedCurrency].name
                                      .toUpperCase();
                            });
                          },
                          children: List.generate(_currencies.length, (
                            int index,
                          ) {
                            return Center(
                              child: Text(
                                _currencies[index].name.toUpperCase(),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: CustomTextInput(
                        controller: _currencyController,
                        placeholder: "Click to select your prefered currency",
                        prefixIcon: CupertinoIcons.money_euro_circle,
                        disabled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton.filled(
                          color: CupertinoColors.systemBlue,
                          child: Text("Save"),
                          onPressed: () {
                            Utils.showConfirmationDialog(
                              context,
                              message:
                                  "Are you sure you want to update your account info?",
                              severity: Severity.normal,
                              action: () {},
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CupertinoButton.tinted(
                          child: Text("Discard"),
                          onPressed: () {
                            Utils.showConfirmationDialog(
                              context,
                              message:
                                  "Are you sure you want to discard the changes you made?",
                              severity: Severity.medium,
                              action: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  CupertinoButton.filled(
                    minimumSize: Size(double.infinity, 0),
                    color: CupertinoColors.destructiveRed,
                    child: Text("Delete Account"),
                    onPressed: () {
                      Utils.showConfirmationDialog(
                        context,
                        message:
                            "Are you sure you want to delete your account?",
                        severity: Severity.high,
                        action: () {},
                      );
                    },
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
