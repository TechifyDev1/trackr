import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/extensions.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/pages/edit_expense_form.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseDetailPage extends ConsumerWidget {
  final Expense expense;
  const ExpenseDetailPage({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(cardsProvider2);
    // final cards = cardAsync.whenData((card) => card);
    final user = ref.watch(userProvider);

    List<Card> cardse = [];
    cardAsync.when(
      data: (cards) {
        cardse = cards;
      },
      error: (e, er) {
        debugPrint(e.toString());
      },
      loading: () => debugPrint("Loading...."),
    );
    Card usedCard = cardse.firstWhere(
      (card) => card.docId == expense.cardDocId,
    );

    final formattedAmount = NumberFormat.currency(
      symbol: user?.currency.currencyIcon,
      decimalDigits: 2,
    ).format(expense.amount);

    // print(usedCard.bank);

    // debugPrint(usedCard.toString());
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Expense Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount
              Center(
                child: Column(
                  children: [
                    Text(
                      formattedAmount,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '${expense.title} • ${expense.category.name}',
                      style: TextStyle(fontSize: 16, color: Color(0xFF8E8E93)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Info section
              _InfoRow(
                icon: CupertinoIcons.calendar,
                label: 'Date',
                value: DateFormat('EEEE, d yyyy hh:mm a').format(expense.date),
              ),
              _InfoRow(
                icon: CupertinoIcons.creditcard,
                label: 'Payment',
                value: "${usedCard.bank}' ${usedCard.network}",
              ),
              _InfoRow(
                icon: CupertinoIcons.folder,
                label: 'Category',
                value: expense.category.name.capitalize(),
              ),

              const SizedBox(height: 30),

              // Description
              const Text(
                'Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                expense.notes,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),

              const SizedBox(height: 40),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.all(8),
                      color: CupertinoColors.systemGrey5,
                      onPressed: () {
                        Utils.showPagePopup(
                          context,
                          EditExpenseForm(expense: expense),
                        );
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.all(8),
                      color: CupertinoColors.systemRed,
                      onPressed: () {
                        Utils.showConfirmationDialog(
                          context,
                          message:
                              "Are you sure you want to delete this expense?",
                          severity: Severity.high,
                          action: () {},
                        );
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(fontWeight: .bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
