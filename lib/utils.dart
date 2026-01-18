import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/models/gemini_response.dart';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse("http://10.156.167.130:3000/insight");

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

  static Future<GeminiResponse> getResponse(String message) async {
    final url = Uri.parse("http://10.156.167.130:3000/chat");
    try {
      final res = await http.post(
        url,
        body: json.encode({"message": message}),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        return GeminiResponse.fromJson(data);
      } else {
        throw {"status": "Error", "message": "Error getting response"};
      }
    } catch (e) {
      debugPrint(e.toString());
      throw "An Unexpected Error orccured";
    }
  }
}
