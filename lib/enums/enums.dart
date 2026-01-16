import 'package:flutter/cupertino.dart';

enum ExpenseCategory {
  housing,
  utilities,
  groceries,
  transportation,
  healthcare,
  dining,
  entertainment,
  shopping,
  miscellaneous,
}

enum Currencies {
  ngn,
  usd;

  String get currencyIcon {
    switch (this) {
      case Currencies.ngn:
        return "N";
      case Currencies.usd:
        return "\$";
    }
  }
}

enum Severity {
  normal,
  medium,
  high;

  Color get color {
    switch (this) {
      case Severity.normal:
        return CupertinoColors.extraLightBackgroundGray;
      case Severity.medium:
        return CupertinoColors.activeOrange;
      case Severity.high:
        return CupertinoColors.destructiveRed;
    }
  }

  IconData get icon {
    switch (this) {
      case Severity.normal:
        return CupertinoIcons.check_mark_circled_solid;
      case Severity.medium:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case Severity.high:
        return CupertinoIcons.xmark_circle_fill;
    }
  }
}
