import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _currPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  final List<Currencies> _currencies = Currencies.values;
  int selectedCurrency = 0;

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

  // @override
  // void initState() {
  //   super.initState();
  //   // ref.read(userProvider.notifier);

  // }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider2);

    return userAsync.when(
      loading: () => const CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (err, stack) => CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        child: Center(child: Text("Error: $err", textAlign: TextAlign.center)),
      ),
      data: (userData) {
        if (_nameController.text.isEmpty) {
          _nameController.text = userData.name;
          _emailControler.text = userData.email;
          _currencyController.text = userData.currency.name.toUpperCase();
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text("Manage your account"),
            trailing: IconButton(
              onPressed: () {
                Utils.showConfirmationDialog(
                  context,
                  message: "Are you sure you want logout?",
                  severity: Severity.medium,
                  action: AuthService.instance.logout,
                );
              },
              icon: const Icon(
                CupertinoIcons.square_arrow_right,
                color: CupertinoColors.destructiveRed,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  userData.photoUrl != null &&
                                      userData.photoUrl!.isNotEmpty
                                  ? NetworkImage(userData.photoUrl!)
                                  : const AssetImage(
                                          "assets/images/9723582.jpg",
                                        )
                                        as ImageProvider,
                            ),
                            const SizedBox(height: 5),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Edit"),
                            ),
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
                      const Text(
                        "New password",
                        style: TextStyle(fontSize: 14),
                      ),
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
                                  this.selectedCurrency = selectedCurrency;
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
                            placeholder:
                                "Click to select your prefered currency",
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
                              onPressed: () {
                                Utils.showConfirmationDialog(
                                  context,
                                  message:
                                      "Are you sure you want to update your account info?",
                                  severity: Severity.normal,
                                  action: () {},
                                );
                              },
                              child: const Text("Save"),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CupertinoButton.tinted(
                              onPressed: () {
                                Utils.showConfirmationDialog(
                                  context,
                                  message:
                                      "Are you sure you want to discard the changes you made?",
                                  severity: Severity.medium,
                                  action: () {},
                                );
                              },
                              child: const Text("Discard"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CupertinoButton.filled(
                        minimumSize: const Size(double.infinity, 0),
                        color: CupertinoColors.destructiveRed,
                        onPressed: () {
                          Utils.showConfirmationDialog(
                            context,
                            message:
                                "Are you sure you want to delete your account?",
                            severity: Severity.high,
                            action: () {},
                          );
                        },
                        child: const Text("Delete Account"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
