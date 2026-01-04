import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/extensions.dart';
import 'package:flutter_application_1/pages/expense_detail_page.dart';
import 'package:flutter_application_1/providers/expense_notifier.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/custom_text_input.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';
import 'package:flutter_application_1/widgets/organisms/expense_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();
    final expensesAsync = ref.watch(expenseProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Expenses"),
        trailing: IconButton(
          onPressed: () => {Utils.showPagePopup(context, ExpenseForm())},
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
                controller: searchController,
                placeholder: "Search",
                prefixIcon: CupertinoIcons.search,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: [
                    Text("Today", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    ...expensesAsync.when(
                      data: (expenses) {
                        return expenses.map(
                          (exp) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ExpenseDetailPage(expense: exp),
                                ),
                              );
                            },
                            child: ExpensesList(
                              title: exp.title,
                              subtitle: exp.category.name.capitalize(),
                              price: exp.amount,
                              transactionType: exp.type,
                            ),
                          ),
                        );
                      },
                      error: (e, er) {
                        debugPrint(e.toString());
                        debugPrint(er.toString());
                        return [
                          Center(child: Text("Error loading your expenses")),
                        ];
                      },
                      loading: () => [
                        Center(child: CupertinoActivityIndicator(radius: 25)),
                      ],
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
