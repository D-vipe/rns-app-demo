import 'package:rns_app/app/features/general/data/dto/app_file_dto.dart';

class EmailDTO {
  final int id;
  final String guid;
  final String from;
  final String to;
  final String body;
  final List<AppFileDTO> fileData;
  final String title;
  final int importance;
  final String dateCreate;

  const EmailDTO({
    required this.id,
    required this.guid,
    required this.from,
    required this.to,
    required this.body,
    required this.fileData,
    required this.title,
    required this.importance,
    required this.dateCreate,
  });

  factory EmailDTO.fromJson(Map<String, dynamic> json) => EmailDTO(
        id: json['id'],
        guid: json['emailGuid'],
        from: json['from'],
        to: json['to'],
        body: json['body'],
        fileData: json['fileData'] != null
            ? json['fileData'].map((json) => AppFileDTO.fromJson(json)).toList().cast<AppFileDTO>()
            : [],
        title: json['title'],
        importance: json['importance'],
        dateCreate: json['dateCreate'],
      );
}
