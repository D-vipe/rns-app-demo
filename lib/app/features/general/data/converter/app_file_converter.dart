import 'package:intl/intl.dart';
import 'package:rns_app/app/features/general/data/dto/app_file_dto.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';

class AppFileConverter {
  static AppFile mapDTO(AppFileDTO data) => AppFile(
        id: data.id,
        title: data.title,
        size: data.size,
        url: data.url,
        description: data.description ?? '',
        author: data.author ?? '',
        fileType: data.fileType,
        dateCreate:
            data.dateCreate != null ? DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data.dateCreate!)) : '',
      );
}
