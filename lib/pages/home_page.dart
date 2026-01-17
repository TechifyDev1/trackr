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
    final user = ref.watch(userProvider);
    final cardAsync = ref.watch(cardsProvider2);
    final totalBalAsync = cardAsync.whenData(
      (cards) => cards.fold(0.0, (sum, card) => sum + card.balance),
    );
    final totalBal = totalBalAsync.value ?? 0.0;
    final currencyIcon = user?.currency.currencyIcon ?? "₦";
    final expensesAsync = ref.watch(expenseProvider);

    final formattedAmount = NumberFormat.currency(
      symbol: currencyIcon,
      decimalDigits: 2,
    ).format(totalBal);

    // if (kDebugMode) {
    //   print(user);
    // }
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        leading: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/qudus.png"),
            ),
            SizedBox(width: 10),
            Text(user?.name ?? "--:--"),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            tabController.index = 3;
          },
          icon: Icon(
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
        behavior: .translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          const Text(
                            "Available on Card",
                            style: TextStyle(
                              color: Color.fromARGB(255, 197, 197, 197),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formattedAmount,
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Column(
                    //     crossAxisAlignment: .start,
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: .spaceBetween,
                    //         children: [
                    //           const Text(
                    //             "Transfer Limit",
                    //             style: TextStyle(fontWeight: .w500),
                    //           ),
                    //           // SizedBox(width: 10),
                    //           const Text(
                    //             "\$12,000",
                    //             style: TextStyle(fontWeight: .w500),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 5),
                    //       Row(
                    //         children: [
                    //           SizedBox(
                    //             height: 2,
                    //             width: MediaQuery.of(context).size.width * 0.3,
                    //             child: Container(color: CupertinoColors.white),
                    //           ),
                    //           SizedBox(
                    //             height: 2,
                    //             width: MediaQuery.of(context).size.width * 0.6,
                    //             child: Container(color: Colors.white30),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 5),
                    //       const Text(
                    //         "Spent \$1,244.65",
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: Color.fromARGB(255, 197, 197, 197),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.showPagePopup(context, ExpenseForm());
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    "Pay",
                                    style: TextStyle(
                                      color: CupertinoColors.darkBackgroundGray,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    CupertinoIcons.money_dollar_circle_fill,
                                    color: CupertinoColors.darkBackgroundGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.showPagePopup(context, ExpenseForm());
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    "Deposit",
                                    style: TextStyle(
                                      color: CupertinoColors.darkBackgroundGray,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    CupertinoIcons.plus_circle_fill,
                                    color: CupertinoColors.darkBackgroundGray,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: CupertinoColors.darkBackgroundGray,
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Align(
                            alignment: .center,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 131, 128, 128),
                              ),
                              child: SizedBox(height: 5, width: 25),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: .spaceBetween,
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
                              final previewExpenses = expenses.take(4);
                              return previewExpenses.map(
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
                                Center(
                                  child: Text("Error loading your expenses"),
                                ),
                              ];
                            },
                            loading: () => [
                              Center(child: CupertinoActivityIndicator()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AiButton(),
          ],
        ),
      ),
    );
  }
}
