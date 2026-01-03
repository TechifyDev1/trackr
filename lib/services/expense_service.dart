import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class ExpenseService {
  ExpenseService._();
  static final instance = ExpenseService._();

  final FirebaseFirestore db = AuthService.instance.db;

  Future<Map<String, dynamic>> saveExpense(Expense expense) async {
    try {
      final cardRef = db
          .collection("cards")
          .doc(AuthService.instance.uid)
          .collection("user_cards")
          .doc(expense.cardDocId);

      final expenseRef = db
          .collection("expenses")
          .doc(AuthService.instance.uid)
          .collection("users_expenses")
          .doc();

      await db.runTransaction((transaction) async {
        final cardSnap = await transaction.get(cardRef);

        if (!cardSnap.exists) {
          throw "Card not found";
        }

        final currentBalance = (cardSnap.data()!["balance"] as num).toDouble();

        if (currentBalance < expense.amount) {
          throw "Insufficient balance on this card please fund the card or select another card";
        }

        //Update balance
        transaction.update(cardRef, {
          "balance": currentBalance - expense.amount,
        });

        //Save expense
        transaction.set(expenseRef, expense.toMap());
      });

      return {"status": "success", "message": "Expense created successfully"};
    } on FirebaseException catch (e) {
      if (e.code == "unavailable") {
        throw "Network error";
      }
      if (e.code == "permission-denied") {
        throw "You are not allowed to create expenses";
      }
      throw "Unexpected error occurred";
    }
  }
}
