import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/extensions.dart';
import 'package:flutter_application_1/pages/expense_detail_page.dart';
import 'package:flutter_application_1/providers/expense_notifier.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardDetailsPage extends ConsumerWidget {
  const CardDetailsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Card details")),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(45, 153, 153, 153),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(68, 0, 0, 0),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Main Card",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "Available balance",
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          "₦231,234,444.00",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.creditcard,
                              size: 16,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "GTBank • Visa",
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton.filled(
                        color: CupertinoColors.activeBlue,
                        child: Text("Edit"),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CupertinoButton.filled(
                        color: CupertinoColors.activeOrange,
                        child: Text("Archive"),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text("Recent expenses"),
                SizedBox(height: 10),
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
                      Center(child: Text("Error loading your recent expenses")),
                    ];
                  },
                  loading: () => [Center(child: CupertinoActivityIndicator())],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
