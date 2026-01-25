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

import 'package:flutter_application_1/providers/user_notifier.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  late TextEditingController _searchController;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        final expensesAsync = ref.watch(expenseProvider);

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CircleAvatar(
              backgroundImage:
                  userData.photoUrl != null && userData.photoUrl!.isNotEmpty
                  ? NetworkImage(userData.photoUrl!)
                  : const AssetImage("assets/images/9723582.jpg"),
            ),
            middle: const Text("Expenses"),
            trailing: IconButton(
              onPressed: () => {
                Utils.showPagePopup(context, const ExpenseForm()),
              },
              icon: const Icon(CupertinoIcons.add),
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
                    controller: _searchController,
                    placeholder: "Search",
                    prefixIcon: CupertinoIcons.search,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 5),
                        ...expensesAsync.when(
                          data: (expenses) {
                            final filteredExpenses = expenses.where((exp) {
                              final title = exp.title.toLowerCase();
                              final category = exp.category.name.toLowerCase();
                              final notes = exp.notes.toLowerCase();
                              return title.contains(_searchQuery) ||
                                  category.contains(_searchQuery) ||
                                  notes.contains(_searchQuery);
                            }).toList();

                            if (filteredExpenses.isEmpty) {
                              return [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      _searchQuery.isEmpty
                                          ? "You currently do not have any expense."
                                          : "No expenses found for \"$_searchQuery\"",
                                    ),
                                  ),
                                ),
                              ];
                            }

                            return filteredExpenses.map(
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
                              const Center(
                                child: Text("Error loading your expenses"),
                              ),
                            ];
                          },
                          loading: () => [
                            const Center(
                              child: CupertinoActivityIndicator(radius: 25),
                            ),
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
      },
    );
  }
}
