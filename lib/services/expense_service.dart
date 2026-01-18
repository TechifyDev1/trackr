import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart' show debugPrint;
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';

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

        final bool isExpense = expense.type.name == "expense";

        final Expense updatedExpense = expense.copyWith(id: expenseRef.id);

        if (currentBalance < expense.amount && isExpense) {
          throw "Insufficient balance on this card please fund the card or select another card";
        }

        //Update balance
        if (isExpense) {
          transaction.update(cardRef, {
            "balance": currentBalance - expense.amount,
          });
        } else {
          transaction.update(cardRef, {
            "balance": currentBalance + expense.amount,
          });
        }

        //Save expense
        transaction.set(expenseRef, updatedExpense.toMap());
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

  Future<List<Expense>> getExpenses() async {
    final res = await db
        .collection("expenses")
        .doc(AuthService.instance.uid)
        .collection("users_expenses")
        .get();
    return res.docs.map((doc) {
      return Expense.fromMap(doc.data());
    }).toList();
  }

  Stream<List<Expense>> watchExpenses() {
    return db
        .collection("expenses")
        .doc(AuthService.instance.uid)
        .collection("users_expenses")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Expense.fromMap(doc.data()))
              .toList();
        })
        .handleError((e) => {print(e)});
  }

  Future<void> updateExpense({required Expense updatedExpense}) async {
    final cardRef = db
        .collection("cards")
        .doc(AuthService.instance.uid)
        .collection("user_cards")
        .doc(updatedExpense.cardDocId);

    final expenseRef = db
        .collection("expenses")
        .doc(AuthService.instance.uid)
        .collection("users_expenses")
        .doc(updatedExpense.id);

    await db.runTransaction((transaction) async {
      try {
        final card = await transaction.get(cardRef);
        final expense = await transaction.get(expenseRef);
        if (!card.exists) throw "Card not found for this expense";
        if (!expense.exists) throw "Card to update not found";
        final existingExpense = Expense.fromMap(expense.data());
        // if (existingExpense.id != updatedExpense.id) {
        //   throw "You don't have permission to edit this expense";
        // }

        double balance = (card.data()!["balance"] as num).toDouble();

        if (existingExpense.type == TransactionType.deposit) {
          balance -= existingExpense.amount;
        } else {
          balance += existingExpense.amount;
        }

        if (updatedExpense.type == TransactionType.expense &&
            balance < updatedExpense.amount) {
          throw "Insufficient balance on this card, fund the card and try again";
        }

        if (updatedExpense.type == TransactionType.deposit) {
          balance += updatedExpense.amount;
        } else {
          balance -= updatedExpense.amount;
        }

        transaction.update(cardRef, {"balance": balance});

        transaction.update(expenseRef, updatedExpense.toMap());
      } on FirebaseException catch (e) {
        if (e.code == "unavailable") throw "Network error";
        if (e.code == "permission-denied") {
          throw "You are not allowed to update expenses";
        }
      } catch (e) {
        debugPrint(e.toString());
        throw e.toString();
      }
    });
  }

  Future<void> deleteExpense({required Expense expense}) async {
    final cardRef = db
        .collection("cards")
        .doc(AuthService.instance.uid)
        .collection("user_cards")
        .doc(expense.cardDocId);

    final expenseRef = db
        .collection("expenses")
        .doc(AuthService.instance.uid)
        .collection("users_expenses")
        .doc(expense.id);
    try {
      await db.runTransaction((transaction) async {
        final cardSnap = await transaction.get(cardRef);
        final expenseSnap = await transaction.get(expenseRef);
        if (!cardSnap.exists) throw "Card not found";
        if (!expenseSnap.exists) throw "Expense not found";
        double balance = (cardSnap.data()!["balance"] as num).toDouble();
        if (expense.type == TransactionType.deposit) {
          balance -= expense.amount;
        } else {
          balance += expense.amount;
        }

        transaction.update(cardRef, {"balance": balance});
        transaction.delete(expenseRef);
      });
    } on FirebaseException catch (e) {
      if (e.code == "unavailable") throw "Network error";
      if (e.code == "permission-denied") {
        throw "You are not allowed to update expenses";
      }
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }
}
