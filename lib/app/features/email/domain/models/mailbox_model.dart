import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class MailBox extends SelectObject {
  final String sign;

  MailBox({
    required super.id,
    required super.title,
    required super.isChecked,
    required this.sign,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MailBox &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          isChecked == other.isChecked &&
          sign == other.sign;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isChecked.hashCode ^ sign.hashCode;
}
