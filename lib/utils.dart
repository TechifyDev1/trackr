import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';

class Utils {
  static void showError(BuildContext context, String err) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          "Error",
          style: TextStyle(color: CupertinoColors.destructiveRed),
        ),
        content: Text(err),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: CupertinoColors.extraLightBackgroundGray),
            ),
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
}
