import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/extensions.dart';
import 'package:flutter_application_1/pages/expense_detail_page.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/providers/expense_notifier.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/ai_button.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';
import 'package:flutter_application_1/widgets/organisms/expense_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  final CupertinoTabController tabController;
  const HomePage({super.key, required this.tabController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider2);
    return userAsync.when(
      loading: () => const CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (err, stack) => CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        child: Center(child: Text("Error: $err", textAlign: .center)),
      ),
      data: (userData) {
        final cardAsync = ref.watch(cardsProvider2);
        final totalBalAsync = cardAsync.whenData(
          (cards) => cards.fold(0.0, (sum, card) => sum + card.balance),
        );
        final totalBal = totalBalAsync.value ?? 0.0;
        final currencyIcon = userData.currency.currencyIcon;
        final expensesAsync = ref.watch(expenseProvider);

        final formattedAmount = NumberFormat.currency(
          symbol: currencyIcon,
          decimalDigits: 2,
        ).format(totalBal);

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.darkBackgroundGray,
          navigationBar: CupertinoNavigationBar(
            leading: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      userData.photoUrl != null && userData.photoUrl!.isNotEmpty
                      ? NetworkImage(userData.photoUrl!)
                      : const AssetImage("assets/images/9723582.jpg"),
                ),
                const SizedBox(width: 10),
                Text(userData.name),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                tabController.index = 3;
              },
              icon: const Icon(
                CupertinoIcons.settings,
                color: CupertinoColors.white,
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: CupertinoColors.darkBackgroundGray,
              ),
              iconSize: 16,
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SizedBox.expand(
              child: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Available on Card",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 197, 197, 197),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formattedAmount,
                                  style: const TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    color: CupertinoColors.white,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Utils.showPagePopup(
                                        context,
                                        const ExpenseForm(),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Pay",
                                          style: TextStyle(
                                            color: CupertinoColors
                                                .darkBackgroundGray,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          CupertinoIcons
                                              .money_dollar_circle_fill,
                                          color: CupertinoColors
                                              .darkBackgroundGray,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CupertinoButton(
                                    color: CupertinoColors.white,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Utils.showPagePopup(
                                        context,
                                        const ExpenseForm(),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Deposit",
                                          style: TextStyle(
                                            color: CupertinoColors
                                                .darkBackgroundGray,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          CupertinoIcons.plus_circle_fill,
                                          color: CupertinoColors
                                              .darkBackgroundGray,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromARGB(
                                        255,
                                        131,
                                        128,
                                        128,
                                      ),
                                    ),
                                    child: const SizedBox(height: 5, width: 25),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Operations"),
                                    TextButton(
                                      onPressed: () {
                                        tabController.index = 1;
                                      },
                                      child: const Text("View all"),
                                    ),
                                  ],
                                ),
                                ...expensesAsync.when(
                                  data: (expenses) {
                                    if (expenses.isEmpty) {
                                      return [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Center(
                                            child: Text(
                                              "You have no recent Transaction",
                                            ),
                                          ),
                                        ),
                                      ];
                                    }
                                    final previewExpenses = expenses.take(3);
                                    return previewExpenses.map(
                                      (exp) => GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  ExpenseDetailPage(
                                                    expense: exp,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: ExpensesList(
                                          title: exp.title,
                                          subtitle: exp.category.name
                                              .capitalize(),
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
                                        child: Text(
                                          "Error loading your expenses",
                                        ),
                                      ),
                                    ];
                                  },
                                  loading: () => [
                                    const Center(
                                      child: CupertinoActivityIndicator(),
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
                  const AiButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
