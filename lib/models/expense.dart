import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';

class Expense {
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final String cardId;
  final String notes;
  final TransactionType type;

  const Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.cardId,
    required this.notes,
    required this.type,
  });

  factory Expense.fromMap(Map<String, dynamic>? expense) {
    return Expense(
      title: expense?["title"],
      amount: expense?["amount"],
      date: expense?["date"],
      category: expense?["category"],
      cardId: expense?["cardId"],
      notes: expense?["notes"],
      type: expense?["type"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "amount": amount,
      "date": date,
      "category": category,
      "cardId": cardId,
      "notes": notes,
      "type": type,
    };
  }
}
