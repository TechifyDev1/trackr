import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/services/expense_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseForm extends ConsumerStatefulWidget {
  const ExpenseForm({super.key});

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoriescontroller = TextEditingController();
  final _notesController = TextEditingController();
  final _typeController = TextEditingController();
  final _cardController = TextEditingController();

  final List<ExpenseCategory> _categories = ExpenseCategory.values;
  final List<TransactionType> _types = TransactionType.values;
  List<Card>? cards;

  int _selectedCategory = 0;
  int _selectedType = 0;
  int _selectedCard = 0;
  bool _loading = false;

  String? _titleError;
  String? _amountError;
  String? _categoryError;
  String? _typeError;

  @override
  void initState() {
    super.initState();
    ref.read(cardsProvider2.future).then((fetchedCards) {
      if (mounted) {
        setState(() {
          cards = fetchedCards;
        });
        if (cards != null && cards!.isNotEmpty) {
          _cardController.text = cards![_selectedCard].bank;
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoriescontroller.dispose();
    _notesController.dispose();
    _typeController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _showCategoriesPopup(Widget picker) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 260,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
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

  bool _validate() {
    bool valid = true;
    if (_titleController.text.isEmpty) {
      _titleError = "Title cannot be empty";
      valid = false;
      return valid;
    }

    if (_amountController.text.isEmpty) {
      _amountError = "Amount cannot be empty";
      valid = false;
      return valid;
    }

    if (_categoriescontroller.text.isEmpty) {
      _categoryError = "Category must be selected";
      valid = false;
      return valid;
    }

    if (_typeController.text.isEmpty) {
      _typeError = "Type must be selected";
      valid = false;
      return valid;
    }

    return valid;
  }

  Future<void> saveExpense(BuildContext context) async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final selectedCard = cards![_selectedCard];
    final isExpense = _typeController.text.toLowerCase() == "expense";
    if (isExpense && amount > selectedCard.balance) {
      if (context.mounted) {
        Utils.showError(
          context,
          "Insufficient balance on this card please fund the card or select another card",
        );
      }
      setState(() {
        _loading = false;
      });
      return;
    }
    if (_loading) return;
    if (!_validate()) return;
    setState(() {
      _loading = true;
    });
    try {
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: DateTime.now(),
        category: ExpenseCategory.values.byName(
          _categoriescontroller.text.toLowerCase(),
        ),
        cardId: cards![_selectedCard].id,
        notes: _notesController.text,
        type: TransactionType.values.byName(_typeController.text.toLowerCase()),
        cardDocId: cards![_selectedCard].docId,
      );
      // print(expense.category);
      await ExpenseService.instance.saveExpense(expense);
      setState(() {
        _loading = false;
      });
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _loading = false;
      });
      if (context.mounted) Utils.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: const Text("New Expense")),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const Text("Title", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _titleController,
                  placeholder: "Title",
                  prefixIcon: CupertinoIcons.pencil,
                ),
                const SizedBox(height: 15),

                const Text("Amount", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _amountController,
                  placeholder: "Amount of expense",
                  prefixIcon: CupertinoIcons.money_dollar,
                  inputType: TextInputType.numberWithOptions(),
                  errorText: _amountError,
                ),
                const SizedBox(height: 15),

                // const Text("Currency", style: TextStyle(fontSize: 14)),
                // const SizedBox(height: 5),
                // CustomTextInput(
                //   controller: _amountController,
                //   placeholder: "Currency",
                //   prefixIcon: CupertinoIcons.money_euro_circle,
                //   errorText: _cur,
                // ),
                // const SizedBox(height: 15),
                const Text("Categories", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    _showCategoriesPopup(
                      CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int selectedCategory) {
                          setState(() {
                            _selectedCategory = selectedCategory;
                            _categoriescontroller.text =
                                _categories[selectedCategory].name;
                          });
                        },
                        children: List.generate(_categories.length, (
                          int index,
                        ) {
                          return Center(child: Text(_categories[index].name));
                        }),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: CustomTextInput(
                      controller: _categoriescontroller,
                      placeholder: "Currency click to choose",
                      prefixIcon: CupertinoIcons.square_grid_2x2,
                      disabled: true,
                      errorText: _categoryError,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                const Text("Card", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    _showCategoriesPopup(
                      CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int selectedCard) {
                          setState(() {
                            _selectedCard = selectedCard;
                            _cardController.text = cards![selectedCard].bank;
                          });
                        },
                        children: List.generate(cards!.length, (int index) {
                          return Center(child: Text(cards![index].bank));
                        }),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: CustomTextInput(
                      controller: _cardController,
                      placeholder: "Select a card",
                      prefixIcon: CupertinoIcons.creditcard,
                      disabled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                const Text("Notes", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _notesController,
                  placeholder: "Notes",
                  prefixIcon: CupertinoIcons.book,
                ),
                const SizedBox(height: 15),

                const Text("Type", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    _showCategoriesPopup(
                      CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int selectedType) {
                          setState(() {
                            _selectedType = selectedType;
                            _typeController.text = _types[selectedType].name;
                          });
                        },
                        children: List.generate(_types.length, (int index) {
                          return Center(child: Text(_types[index].name));
                        }),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: CustomTextInput(
                      controller: _typeController,
                      placeholder: "Transaction type (click to choose)",
                      prefixIcon: CupertinoIcons.arrow_up_arrow_down,
                      disabled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: () {
                      saveExpense(context);
                    },
                    color: CupertinoColors.extraLightBackgroundGray,
                    child: _loading
                        ? const CupertinoActivityIndicator(
                            radius: 10,
                            color: CupertinoColors.darkBackgroundGray,
                          )
                        : Text(
                            "Save Expense",
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
