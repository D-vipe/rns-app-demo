import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';

class Email {
  final int id;
  final String guid;
  final List<String> fromList;
  final String from;
  final String to;
  final String body;
  final List<AppFile> fileData;
  final String title;
  final Importance importance;
  final DateTime dateCreate;

  const Email({
    required this.id,
    required this.guid,
    required this.from,
    required this.fromList,
    required this.to,
    required this.body,
    required this.fileData,
    required this.title,
    required this.importance,
    required this.dateCreate,
  });

  Email copyWith({List<AppFile>? fileData}) => Email(
        id: id,
        guid: guid,
        from: from,
        fromList: fromList,
        to: to,
        body: body,
        fileData: fileData ?? this.fileData,
        title: title,
        importance: importance,
        dateCreate: dateCreate,
      );
}
