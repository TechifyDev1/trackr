import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/models/chat/history.dart';
import 'package:flutter_application_1/models/chat/message.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/models/insights/part.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/pages/ai_insight_page.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/providers/expense_notifier.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_application_1/services/card_service.dart';
import 'package:flutter_application_1/services/expense_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Utils {
  static void showDialog({
    required BuildContext context,
    required String message,
    required Severity severity,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        // Title row with icon + text
        title: Row(
          children: [
            Icon(severity.icon, color: severity.color, size: 24),
            const SizedBox(width: 8),
            Text(
              severity == Severity.normal
                  ? "Success"
                  : severity == Severity.medium
                  ? "Warning"
                  : "Error",
              style: TextStyle(
                color: severity.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok', style: TextStyle(color: severity.color)),
          ),
        ],
      ),
    );
  }

  static void showPagePopup(BuildContext context, Widget child) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => child, fullscreenDialog: true),
    );
  }

  static void showConfirmationDialog(
    BuildContext context, {
    required String message,
    required Severity severity,
    required void Function() action,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Are you sure?", style: TextStyle(color: severity.color)),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: CupertinoColors.extraLightBackgroundGray,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                action();
                Navigator.pop(context);
              },
              child: Text("Proceed", style: TextStyle(color: severity.color)),
            ),
          ],
        );
      },
    );
  }

  static Widget archivedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(223, 142, 142, 147),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "ARCHIVED",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.white,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  static Future<String> getInsight(Expense expense) async {
    final url = Uri.parse("http://10.62.167.130:3000/insight");

    try {
      final res = await http.post(
        url,
        body: json.encode({"object": expense.toMap()}),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        return data["res"]["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        throw {"status": "Error", "message": "Error getting response"};
      }
    } catch (e) {
      debugPrint(e.toString());
      throw "An Unexpected Error orccured";
    }
  }

  static Future<String> getResponse(
    Message message,
    WidgetRef ref, {
    void Function(String, {bool isDone})? onIntent,
  }) async {
    final url = Uri.parse("http://10.62.167.130:3000/chat");
    try {
      final res = await http.post(
        url,
        body: json.encode({"message": message.toJson()}),
        headers: {"Content-Type": "application/json"},
      );
      debugPrint(res.body);
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        if (data["type"] == "function_call") {
          final calls = data["calls"] as List?;
          if (calls == null || calls.isEmpty) {
            throw Exception("Function call requested but no calls provided");
          }
          final call = calls.first;
          final String functionName = call["name"];
          final Map<String, dynamic> args = call["args"] ?? {};

          final res = await parseFunctionCall(
            functionName,
            args,
            ref,
            onIntent: onIntent,
          );
          return getResponse(res["message"], res["ref"], onIntent: onIntent);
        } else {
          final content = data["content"]?.toString() ?? "";
          if (content.isEmpty) {
            return "I have retrieved the information, but I'm having trouble formatting the response. Your balance is \$balance.";
          }
          return content;
        }
      } else {
        throw "Error getting response: ${res.statusCode}";
      }
    } catch (e) {
      debugPrint("GetResponse Error: $e");
      throw "An Unexpected Error occurred during chat";
    }
  }

  static String getBalance(WidgetRef ref) {
    final cards = ref.read(cardsProvider2).value ?? [];
    final totalBal = cards.fold(0.0, (sum, card) => sum + card.balance);

    final user = ref.read(userProvider);

    return NumberFormat.currency(
      symbol: user?.currency.currencyIcon ?? "₦",
      decimalDigits: 2,
    ).format(totalBal);
  }

  static Future<Map<String, dynamic>> parseFunctionCall(
    String functionName,
    Map<String, dynamic> args,
    WidgetRef ref, {
    void Function(String, {bool isDone})? onIntent,
  }) async {
    InsightHistoryState.history.add(
      History(
        role: "model",
        parts: [
          Part(functionCall: {"name": functionName, "args": args}),
        ],
      ),
    );
    switch (functionName) {
      case "getBalance":
        onIntent?.call("checking your balance...", isDone: false);
        final String balance = getBalance(ref);
        onIntent?.call("checked your balance", isDone: true);
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: The call to $functionName was successful. The result is: $balance. Continue reasoning using this data.",
              ),
            ],
          ),
        );
        break;
      case "getTransactions":
        onIntent?.call("fetching your transactions...", isDone: false);
        final expAsync = ref.read(expenseProvider);
        final expenses = expAsync.value ?? [];
        onIntent?.call("fetched your transactions", isDone: true);
        final summary = expenses.isEmpty
            ? "No transactions found."
            : expenses.map((e) => e.toDetailedString(ref)).join("\n");
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: Retrieved ${expenses.length} transactions.\n$summary\nContinue reasoning using this data.",
              ),
            ],
          ),
        );
        break;

      case "getUserDetails":
        onIntent?.call("retrieving user details...", isDone: false);
        final userAsync = ref.read(userProvider2);
        final User? user = userAsync.value;
        onIntent?.call("retrieved user details", isDone: true);
        final summery = user == null
            ? "No user infomation provided"
            : user.toString();
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: Retrieved $summery\n Continue reasoning using this data",
              ),
            ],
          ),
        );
        break;

      case "getCards":
        onIntent?.call("retrieving your cards...", isDone: false);
        final cardAsync = ref.read(cardsProvider2);
        final cards = cardAsync.value ?? [];
        onIntent?.call("retrieved your cards", isDone: true);
        final summery = cards.isEmpty
            ? "No cards found"
            : cards.map((e) => e.toString()).join("\n");
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: Retrieved $summery \n Continue reasoning using this data",
              ),
            ],
          ),
        );

        break;

      case "createTransaction":
        onIntent?.call("creating a new transaction...", isDone: false);
        final String title = args["title"];
        final num rawAmount = args["amount"];
        final String categoryRaw = args["category"];
        final String cardId = args["cardId"];
        final String? cardDocId = args["cardDocId"];
        final String? notes = args["notes"] ?? "";
        final String typeRaw = args["type"];

        final expense = Expense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          amount: rawAmount.toDouble(),
          date: DateTime.now(),
          category: .values.byName(categoryRaw),
          cardId: cardId,
          notes: notes ?? "",
          type: .values.byName(typeRaw),
          cardDocId: cardDocId,
        );

        try {
          await ExpenseService.instance.saveExpense(expense);
        } catch (e) {
          throw Exception(
            "Unable to create expense, ${expense.toDetailedString(ref)}",
          );
        }
        onIntent?.call("created a new transaction", isDone: true);
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: Transaction created successfully.\n${expense.toDetailedString(ref)}",
              ),
            ],
          ),
        );

        break;

      case "updateExpense":
        onIntent?.call("updating transaction details...", isDone: false);
        final String? title = args["title"];
        final String expenseId = args["expenseId"];
        final String? notes = args["notes"];
        final num? rawAmount = args["amount"];

        final expenseListAsync = ref.read(expenseProvider);
        final expenseList = expenseListAsync.value ?? [];
        final expenseToUpdate = expenseList.firstWhere(
          (exp) => exp.id == expenseId,
        );
        final updatedExpense = expenseToUpdate.copyWith(
          title: title,
          notes: notes,
          amount: rawAmount?.toDouble(),
        );
        // final summery = expenseList.isEmpty
        //     ? "There is no expense to update"
        //     : expenseToUpdate.toDetailedString(ref);
        try {
          await ExpenseService.instance.updateExpense(
            updatedExpense: updatedExpense,
          );
        } catch (e) {
          throw Exception(
            "Unable to update expense, ${expenseToUpdate.toDetailedString(ref)}",
          );
        }
        onIntent?.call("updated transaction details", isDone: true);

        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: Transaction updated successfully.\n${updatedExpense.toDetailedString(ref)}",
              ),
            ],
          ),
        );
        break;

      case "archiveCard":
        onIntent?.call("archiving your card...", isDone: false);
        final String cardDocId = args["cardDocId"];
        try {
          await CardService.instance.archiveCard(cardDocId);
        } catch (e) {
          throw Exception(e);
        }
        onIntent?.call("archived your card", isDone: true);
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: Card with id $cardDocId archived successfully.",
              ),
            ],
          ),
        );
        break;
      case "activateCard":
        onIntent?.call("activating your card...", isDone: false);
        final String cardDocId = args["cardDocId"];
        try {
          await CardService.instance.activate(cardDocId);
        } catch (e) {
          throw Exception(e);
        }
        onIntent?.call("activated your card", isDone: true);
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text:
                    "SYSTEM_RESULT: Card with id $cardDocId activated successfully.",
              ),
            ],
          ),
        );

        break;
      case "createCard":
        onIntent?.call("creating a new card...", isDone: false);
        final Card newCard = Card(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nickname: args["nickname"],
          type: args["cardType"],
          network: args["cardNetworkType"],
          last4: args["last4Digit"],
          balance: (args["balance"] as num).toDouble(),
          bank: args["bank"],
          createdAt: DateTime.now(),
        );

        try {
          await CardService.instance.saveCard(newCard);
        } catch (e) {
          throw Exception(e);
        }
        onIntent?.call("created a new card", isDone: true);
        InsightHistoryState.history.add(
          History(
            role: "user",
            parts: [
              Part(
                text: "SYSTEM_RESULT: Card card created with id ${newCard.id}",
              ),
            ],
          ),
        );
        break;

      default:
        throw Exception("Unknown function called, $functionName");
    }
    final followUp = Message(
      message: "Continue reasoning using the system result above.",
      history: [...InsightHistoryState.history],
    );
    return {"message": followUp, "ref": ref};
  }

  static Card getCardUsed(Expense expense, WidgetRef ref) {
    final cardsAsync = ref.read(cardsProvider2);
    final cards = cardsAsync.value ?? [];
    if (cards.isEmpty) {
      throw Exception("No cards");
    }
    final cardDocId = expense.cardDocId;
    final cardUsed = cards.firstWhere((card) => card.docId == cardDocId);
    return cardUsed;
  }
}
