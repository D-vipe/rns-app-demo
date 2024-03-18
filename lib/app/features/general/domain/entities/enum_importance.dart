import 'package:get/get_utils/get_utils.dart';

enum Importance { no, low, normal, high }

extension ImportanceExtension on Importance {
  String get displayTitle {
    switch (this) {
      case Importance.no:
        return 'messages_importance_no'.tr;
      case Importance.low:
        return 'messages_importance_low'.tr;
      case Importance.normal:
        return 'messages_importance_normal'.tr;
      case Importance.high:
        return 'messages_importance_high'.tr;
    }
  }

  String get apiValue {
    switch (this) {
      case Importance.no:
        return '';
      case Importance.low:
        return 'low';
      case Importance.normal:
        return 'normal';
      case Importance.high:
        return 'high';
    }
  }
}
