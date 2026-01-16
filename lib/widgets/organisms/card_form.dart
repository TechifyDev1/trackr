import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/services/card_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';

class CardForm extends StatefulWidget {
  const CardForm({super.key});
  @override
  State<CardForm> createState() {
    return _CardFormState();
  }
}

const List<String> _cardTypes = ["Debit", "Credit", "Prepaid"];
const List<String> _cardNetworkType = [
  "Visa",
  "MasterCard",
  "Verve",
  "UnionPage",
];
const double _kItemExtent = 32.0;

class _CardFormState extends State<CardForm> {
  late TextEditingController _nicknameController;
  late TextEditingController _cardTypeController;
  late TextEditingController _cardNetWorkTypeController;
  late TextEditingController _cardLastNumsController;
  late TextEditingController _bankController;
  late TextEditingController _balanceController;

  int selectedCardNetworkType = 0;
  int _selectedCardType = 0;
  late bool _loading;

  final List<Currencies> currencies = Currencies.values;
  int selectedCurrency = 0;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: "");
    _cardTypeController = TextEditingController(text: "");
    _cardNetWorkTypeController = TextEditingController(text: "");
    _cardLastNumsController = TextEditingController(text: "");
    _bankController = TextEditingController(text: "");
    _balanceController = TextEditingController(text: "");
    _loading = false;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _cardTypeController.dispose();
    _cardNetWorkTypeController.dispose();
    _cardLastNumsController.dispose();
    _bankController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _showTypePopup(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(top: false, child: child),
      ),
    );
  }

  String? _nicknameError;
  String? _cardTypeError;
  String? _cardNetworkTypeError;
  String? _lastNumsError;
  String? _bankError;
  String? _balanceError;

  bool _validate() {
    bool valid = true;

    // Nickname
    if (_nicknameController.text.trim().isEmpty) {
      _nicknameError = "Nickname is required";
      valid = false;
    } else {
      _nicknameError = null;
    }

    // Card type
    if (_cardTypeController.text.trim().isEmpty) {
      _cardTypeError = "Select a card type";
      valid = false;
    } else {
      _cardTypeError = null;
    }

    // Card network
    if (_cardNetWorkTypeController.text.trim().isEmpty) {
      _cardNetworkTypeError = "Select a card network";
      valid = false;
    } else {
      _cardNetworkTypeError = null;
    }

    // Last four digits
    final lastNums = _cardLastNumsController.text.trim();
    if (lastNums.isEmpty) {
      _lastNumsError = "Last 4 digits required";
      valid = false;
    } else if (lastNums.length != 4) {
      _lastNumsError = "Must be exactly 4 digits";
      valid = false;
    } else {
      _lastNumsError = null;
    }

    // Bank
    if (_bankController.text.trim().isEmpty) {
      _bankError = "Bank name is required";
      valid = false;
    } else {
      _bankError = null;
    }

    // Balance
    final balance = double.tryParse(_balanceController.text.trim());
    if (balance == null || balance < 0) {
      _balanceError = "Enter a valid amount";
      valid = false;
    } else {
      _balanceError = null;
    }

    if (mounted) {
      setState(() {});
    }

    return valid;
  }

  Future<void> saveCard(BuildContext context) async {
    if (_loading) return;
    if (!_validate()) return;
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    final card = Card(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nickname: _nicknameController.text,
      type: _cardTypeController.text,
      network: _cardNetWorkTypeController.text,
      last4: int.parse(_cardLastNumsController.text),
      balance: double.parse(_balanceController.text),
      bank: _bankController.text,
      createdAt: DateTime.now(),
    );
    try {
      await CardService.instance.saveCard(card);
      if (mounted) {
        setState(() {
          _loading = false;
        });
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Add a card")),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const Text("Nickname", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _nicknameController,
                  placeholder: "Nickname on card",
                  errorText: _nicknameError,
                  onChanged: (value) {
                    if (_nicknameError != null) _nicknameError = null;
                  },
                ),
                const SizedBox(height: 15),
                const Text("Type", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showTypePopup(
                    CupertinoPicker(
                      itemExtent: _kItemExtent,
                      magnification: 1.2,
                      squeeze: 1.2,
                      useMagnifier: true,
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedCardType,
                      ),
                      onSelectedItemChanged: (int selectedType) {
                        setState(() {
                          _selectedCardType = selectedType;
                          _cardTypeController.text = _cardTypes[selectedType];
                        });
                      },
                      children: List.generate(_cardTypes.length, (int index) {
                        return Center(child: Text(_cardTypes[index]));
                      }),
                    ),
                  ),

                  child: AbsorbPointer(
                    absorbing: true,
                    child: CustomTextInput(
                      controller: _cardTypeController,
                      placeholder: "Click to select card type",
                      disabled: true,
                      prefixIcon: CupertinoIcons.creditcard,
                      errorText: _cardTypeError,
                      onChanged: (value) {
                        if (_cardTypeError != null) {
                          setState(() {
                            _cardTypeError = null;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                const Text("Network", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showTypePopup(
                    CupertinoPicker(
                      itemExtent: _kItemExtent,
                      magnification: 1.2,
                      squeeze: 1.2,
                      useMagnifier: true,
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedCardType,
                      ),
                      onSelectedItemChanged: (int selectedType) {
                        setState(() {
                          selectedCardNetworkType = selectedType;
                          _cardNetWorkTypeController.text =
                              _cardNetworkType[selectedType];
                        });
                      },
                      children: List.generate(_cardNetworkType.length, (
                        int index,
                      ) {
                        return Center(child: Text(_cardNetworkType[index]));
                      }),
                    ),
                  ),

                  child: AbsorbPointer(
                    absorbing: true,
                    child: CustomTextInput(
                      controller: _cardNetWorkTypeController,
                      placeholder: "Click to select card network",
                      disabled: true,
                      prefixIcon: CupertinoIcons.antenna_radiowaves_left_right,
                      errorText: _cardNetworkTypeError,
                      onChanged: (value) {
                        if (_cardNetworkTypeError != null) {
                          _cardNetworkTypeError = null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                const Text("Last four digit", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _cardLastNumsController,
                  placeholder: "Last four digit of your card",
                  inputType: TextInputType.number,
                  prefixIcon: CupertinoIcons.asterisk_circle,
                  errorText: _lastNumsError,
                  onChanged: (value) {
                    setState(() {
                      if (_lastNumsError != null) {
                        _lastNumsError = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 15),

                const Text("Bank", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _bankController,
                  placeholder: "Bank Name",
                  prefixIcon: CupertinoIcons.house_alt,
                  errorText: _bankError,
                  onChanged: (value) {
                    setState(() {
                      if (_bankError != null) {
                        _bankError = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 15),

                const Text("Balance", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _balanceController,
                  placeholder: "Amount on card",
                  errorText: _balanceError,
                  inputType: TextInputType.numberWithOptions(),
                  onChanged: (value) {
                    setState(() {
                      if (_balanceError != null) _balanceError = null;
                    });
                  },
                ),
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: () {
                      saveCard(context);
                    },
                    color: CupertinoColors.extraLightBackgroundGray,
                    child: _loading
                        ? const CupertinoActivityIndicator(
                            radius: 10,
                            color: CupertinoColors.darkBackgroundGray,
                          )
                        : Text(
                            "Create card",
                            style: TextStyle(
                              color: CupertinoColors.darkBackgroundGray,
                            ),
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
