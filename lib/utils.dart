import 'package:flutter/cupertino.dart';

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
}
