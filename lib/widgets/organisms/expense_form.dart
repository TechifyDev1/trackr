import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoriescontroller = TextEditingController();
  final _notesController = TextEditingController();
  final _typeController = TextEditingController();

  final List<ExpenseCategory> _categories = ExpenseCategory.values;
  final List<TransactionType> _types = TransactionType.values;

  int _selectedCategory = 0;
  int _selectedType = 0;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoriescontroller.dispose();
    _notesController.dispose();
    _typeController.dispose();
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
                ),
                const SizedBox(height: 15),

                const Text("Currency", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _amountController,
                  placeholder: "Currency",
                  prefixIcon: CupertinoIcons.money_euro_circle,
                ),
                const SizedBox(height: 15),

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
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                const Text("Card", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _amountController,
                  placeholder: "Select a card",
                  prefixIcon: CupertinoIcons.creditcard,
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
                      // signUp(context);
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
