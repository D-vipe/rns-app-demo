import 'package:get/get_utils/get_utils.dart';

enum ReceiverType { to, copy, secretCopy }

extension ReceiverTypeExtension on ReceiverType {
  String get displayTitle {
    switch (this) {
      case ReceiverType.to:
        return 'messages_label_sendTo'.tr;
      case ReceiverType.copy:
        return 'messages_label_sendCopy'.tr;
      case ReceiverType.secretCopy:
        return 'messages_label_sendSecretCopy'.tr;
    }
  }
}
