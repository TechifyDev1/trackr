import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/models/chat/history.dart';
import 'package:flutter_application_1/models/chat/message.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/models/insights/gemini_response.dart';
import 'package:flutter_application_1/models/insights/part.dart';
import 'package:flutter_application_1/pages/ai_insight_page.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
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

  static Future<GeminiResponse> getInsight(Expense expense) async {
    final url = Uri.parse("http://10.156.167.130:3001/insight");

    try {
      final res = await http.post(
        url,
        body: json.encode({"object": expense.toMap()}),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        return GeminiResponse.fromJson(data["res"]);
      } else {
        throw {"status": "Error", "message": "Error getting response"};
      }
    } catch (e) {
      debugPrint(e.toString());
      throw "An Unexpected Error orccured";
    }
  }

  static Future<String> getResponse(Message message, WidgetRef ref) async {
    final url = Uri.parse("http://10.156.167.130:3001/chat");
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
          final call = data["calls"][0];
          final String functionName = call["name"];
          final Map<String, dynamic> args = call["args"] ?? {};

          switch (functionName) {
            case "getBalance":
              // 1. Add the Model's Function Call to history
              InsightHistoryState.history.add(
                History(
                  role: "model",
                  parts: [
                    Part(functionCall: {"name": functionName, "args": args}),
                  ],
                ),
              );

              final String balance = getBalance(ref);
              print(balance);

              // 2. Add the Function's Response to history
              InsightHistoryState.history.add(
                History(
                  role: "function",
                  parts: [
                    Part(
                      functionResponse: {
                        "name": functionName,
                        "response": {"content": balance},
                      },
                    ),
                  ],
                ),
              );

              // 3. Follow up with the model to process the result
              final Message followUp = Message(
                message: "Process the function result and provide the insight.",
                history: List.from(InsightHistoryState.history),
              );

              return getResponse(followUp, ref);

            default:
              throw "Unknown function call: $functionName";
          }
        } else {
          return data["content"];
        }
      } else {
        throw "Error getting response";
      }
    } catch (e) {
      debugPrint(e.toString());
      throw "An Unexpected Error orccured";
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
}
