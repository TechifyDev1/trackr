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
        });
  }

  Future<void> updateExpense({
    required Expense oldExpense,
    required Expense updatedExpense,
  }) async {
    try {
      final oldCardRef = db
          .collection("cards")
          .doc(AuthService.instance.uid)
          .collection("user_cards")
          .doc(oldExpense.cardDocId);

      final newCardRef = db
          .collection("cards")
          .doc(AuthService.instance.uid)
          .collection("user_cards")
          .doc(updatedExpense.cardDocId);

      final expenseRef = db
          .collection("expenses")
          .doc(AuthService.instance.uid)
          .collection("users_expenses")
          .doc(oldExpense.id);

      await db.runTransaction((transaction) async {
        // Fetch old card
        final oldCardSnap = await transaction.get(oldCardRef);
        if (!oldCardSnap.exists) {
          throw "Original card not found";
        }

        double oldCardBalance = (oldCardSnap.data()!["balance"] as num)
            .toDouble();

        // Reverse old transaction
        if (oldExpense.type.name == "expense") {
          oldCardBalance += oldExpense.amount;
        } else {
          oldCardBalance -= oldExpense.amount;
        }

        transaction.update(oldCardRef, {"balance": oldCardBalance});

        // Fetch new card (may be same)
        final newCardSnap = oldExpense.cardDocId == updatedExpense.cardDocId
            ? oldCardSnap
            : await transaction.get(newCardRef);

        if (!newCardSnap.exists) {
          throw "Selected card not found";
        }

        double newCardBalance = (newCardSnap.data()!["balance"] as num)
            .toDouble();

        // Validate balance if new transaction is expense
        if (updatedExpense.type.name == "expense" &&
            newCardBalance < updatedExpense.amount) {
          throw "Insufficient balance on selected card";
        }

        // Apply new transaction
        if (updatedExpense.type.name == "expense") {
          newCardBalance -= updatedExpense.amount;
        } else {
          newCardBalance += updatedExpense.amount;
        }

        transaction.update(newCardRef, {"balance": newCardBalance});

        // Update expense document
        transaction.update(expenseRef, updatedExpense.toMap());
      });
    } on FirebaseException catch (e) {
      if (e.code == "unavailable") {
        throw "Network error";
      }
      if (e.code == "permission-denied") {
        throw "You are not allowed to update expenses";
      }
      throw "Failed to update expense";
    }
  }
}
