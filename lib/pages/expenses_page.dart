import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';
import 'package:flutter_application_1/widgets/organisms/expense_form.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Expenses"),
        trailing: IconButton(
          onPressed: () => {Utils.showForm(context, ExpenseForm())},
          icon: Icon(CupertinoIcons.add),
          iconSize: 16,
          color: CupertinoColors.extraLightBackgroundGray,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextInput(
                nameController: searchController,
                placeholder: "Search",
                prefixIcon: CupertinoIcons.search,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: const [
                    Text("Today", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    ExpensesList(
                      title: "AT & T",
                      subtitle: "Unlimited Family plan",
                      price: "39.99",
                    ),
                    SizedBox(height: 5),
                    ExpensesList(
                      title: "CC subscription",
                      subtitle: "Unlimited Family plan",
                      price: "39.99",
                    ),
                    SizedBox(height: 12),
                    Text("Yesterday", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    ExpensesList(
                      title: "Netflix",
                      subtitle: "Basic plan",
                      price: "39.99",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
