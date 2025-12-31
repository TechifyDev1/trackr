import 'package:flutter/cupertino.dart';
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
  "America Express (Amex)",
  "Discover",
  "UnionPage",
];
const double _kItemExtent = 32.0;

class _CardFormState extends State<CardForm> {
  late TextEditingController _nicknameController;
  late TextEditingController _cardTypeController;
  late TextEditingController _cardNetWorkTypeController;
  late TextEditingController _cardLastNumsController;
  late TextEditingController _bankController;
  late TextEditingController _currencyController;
  late TextEditingController _balanceController;

  int _selectedCardNetworkType = 0;
  int _selectedCardType = 0;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: "");
    _cardTypeController = TextEditingController(text: "");
    _cardNetWorkTypeController = TextEditingController(text: "");
    _cardLastNumsController = TextEditingController(text: "");
    _bankController = TextEditingController(text: "");
    _currencyController = TextEditingController(text: "");
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
    _currencyController.dispose();
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
                          _selectedCardNetworkType = selectedType;
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
                ),
                const SizedBox(height: 15),

                const Text("Bank", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _bankController,
                  placeholder: "Bank Name",
                  prefixIcon: CupertinoIcons.house_alt,
                ),
                const SizedBox(height: 15),

                const Text("Currency", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _currencyController,
                  placeholder: "Currency on card",
                  prefixIcon: CupertinoIcons.money_dollar,
                  disabled: true,
                ),
                const SizedBox(height: 15),

                const Text("Balance", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _balanceController,
                  placeholder: "Amount on card",
                ),
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: () {
                      // signUp(context);
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
