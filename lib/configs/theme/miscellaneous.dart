import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnicodeSymbols {
  static const String rubleSign = '\u20bd';
  static const String dollarSign = '\u0024';
  static const String euroSign = '\u20ac';
  static const String celciumSign = '\u00B0 C';
}

class AppMiscConstants {
  static const int resendTimer = 10;
}

// Различные размеры (padding, margin)
class AppConstraints {
  static const double screenPadding = 16.0;
}

class LocalizeTooltips {
  static String getBtnLbl(ContextMenuButtonItem buttonItem) {
    switch (buttonItem.type) {
      case ContextMenuButtonType.cut:
        return 'contextButton_cut'.tr;
      case ContextMenuButtonType.copy:
        return 'contextButton_copy'.tr;
      case ContextMenuButtonType.paste:
        return 'contextButton_paste'.tr;
      case ContextMenuButtonType.selectAll:
        return 'contextButton_selectAll'.tr;
      case ContextMenuButtonType.delete:
        return 'contextButton_delete'.tr;
      default:
        return '';
    }
  }
}
