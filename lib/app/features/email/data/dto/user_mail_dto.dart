import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';

class MailBoxDTO extends SelectObjectDTO {
  final String sign;

  MailBoxDTO({
    required super.id,
    required super.title,
    required super.isChecked,
    required this.sign,
  });

  factory MailBoxDTO.fromJson(Map<String, dynamic> json) => MailBoxDTO(
        id: json['id'] ?? '0',
        title: json['title'] ?? '',
        isChecked: json['isChecked'] ?? false,
        sign: json['sign'],
      );
}
