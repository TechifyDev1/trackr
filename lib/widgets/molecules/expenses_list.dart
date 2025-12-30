import 'package:flutter/cupertino.dart';

enum TransactionType {
  expense,
  deposit;

  bool get isExpense => this == TransactionType.expense;

  IconData get icon {
    switch (this) {
      case TransactionType.deposit:
        return CupertinoIcons.arrow_up_circle_fill;
      case TransactionType.expense:
        return CupertinoIcons.arrow_down_circle_fill;
    }
  }

  String formatAmount(String amount) {
    return isExpense ? "-₦$amount" : "+₦$amount";
  }
}

class ExpensesList extends StatelessWidget {
  final String title;
  final String subtitle;
  final TransactionType transactionType;
  final String price;
  const ExpensesList({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.transactionType = TransactionType.deposit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 131, 128, 128)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CupertinoListTile(
        leading: Icon(
          transactionType.icon,
          size: 28,
          color: CupertinoColors.extraLightBackgroundGray,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          transactionType.formatAmount(price),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
