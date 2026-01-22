import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final String cardId;
  final String notes;
  final TransactionType type;
  final String? cardDocId;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.cardId,
    required this.notes,
    required this.type,
    this.cardDocId,
  });

  factory Expense.fromMap(Map<String, dynamic>? expense) {
    DateTime parsedDate;
    var dateValue = expense?["date"];

    if (dateValue is Timestamp) {
      parsedDate = dateValue.toDate();
    } else if (dateValue is String) {
      parsedDate = DateTime.parse(dateValue);
    } else {
      parsedDate = DateTime.now();
    }
    return Expense(
      id: expense?["id"],
      title: expense?["title"],
      amount: expense?["amount"],
      date: parsedDate,
      category: ExpenseCategory.values.byName(expense?["category"]),
      cardId: expense?["cardId"],
      notes: expense?["notes"],
      type: TransactionType.values.byName(expense?["type"]),
      cardDocId: expense?["cardDocId"],
    );
  }

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    ExpenseCategory? category,
    String? cardId,
    String? notes,
    TransactionType? type,
    String? cardDocId,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      cardId: cardId ?? this.cardId,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      cardDocId: cardDocId ?? this.cardDocId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "amount": amount,
      "date": date.toIso8601String(),
      "category": category.name,
      "cardId": cardId,
      "notes": notes,
      "type": type.name,
      "cardDocId": cardDocId,
    };
  }

  String toDetailedString(WidgetRef ref) {
    final Expense currentExp = this;
    final cardUsed = Utils.getCardUsed(currentExp, ref);
    return "id: $id, title: $title, amount: ${amount.toString()}, date: $date, category: ${category.name}, cardInfo: ${cardUsed.toString()}, notes: $notes, type: ${type.name}, cardDocId: $cardDocId";
  }
}
