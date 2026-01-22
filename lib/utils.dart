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

  static Future<String> getResponse(Message message, WidgetRef ref) async {
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

          final res = parseFunctionCall(functionName, args, ref);

          return getResponse(res["message"], res["ref"]);
        } else {
          final content = data["content"]?.toDetailedString() ?? "";
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

  static Map<String, dynamic> parseFunctionCall(
    String functionName,
    Map<String, dynamic> args,
    WidgetRef ref,
  ) {
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
        final String balance = getBalance(ref);
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
        final Message followUp = Message(
          message: "Continue reasoning using the system result above.",
          history: [...InsightHistoryState.history],
        );
        return {"message": followUp, "ref": ref};

      case "getTransactions":
        final expAsync = ref.read(expenseProvider);
        final expenses = expAsync.value ?? [];
        final summary = expenses.isEmpty
            ? "No transactions found."
            : expenses.map((e) => e.toDetailedString(ref));
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
        final Message followUp = Message(
          message: "Continue reasoning using the system result above.",
          history: [...InsightHistoryState.history],
        );
        return {"message": followUp, "ref": ref};

      case "getUserDetails":
        final userAsync = ref.read(userProvider2);
        final User? user = userAsync.value;
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
        final followUp = Message(
          message: "Continue reasoning using the system result above.",
          history: [...InsightHistoryState.history],
        );
        return {"message": followUp, "ref": ref};

      case "getCards":
        final cardAsync = ref.read(cardsProvider2);
        final cards = cardAsync.value ?? [];
        final summery = cards.isEmpty
            ? "No cards found"
            : cards.map((e) => e.toString());
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
        final followUp = Message(
          message: "Continue reasoning using the system result above.",
          history: [...InsightHistoryState.history],
        );
        return {"message": followUp, "ref": ref};

      default:
        throw Exception("Unknown function called, $functionName");
    }
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
