import 'package:rns_app/app/features/email/data/converters/importance_converter.dart';
import 'package:rns_app/app/features/email/data/dto/email_dto.dart';
import 'package:rns_app/app/features/email/domain/models/email_model.dart';
import 'package:rns_app/app/features/general/data/converter/app_file_converter.dart';

class EmailConverter {
  static Email mapDTO(EmailDTO data) => Email(
        id: data.id,
        guid: data.guid,
        from: data.from,
        fromList: _convertToEmailList(data.from),
        to: data.to,
        body: data.body,
        fileData: data.fileData.map((data) => AppFileConverter.mapDTO(data)).toList(),
        title: data.title,
        importance: ImportanceConverter.convert(data.importance),
        dateCreate: DateTime.parse(data.dateCreate),
      );
}

List<String> _convertToEmailList(String data) {
  final List<String> fromList = data.split(';').map((e) => _getEmailAddress(e)).toList();
  final List<String> filteredList = [];
  for (var item in fromList) {
    if (item.isNotEmpty) {
      filteredList.add(item);
    }
  }

  return filteredList;
}

String _getEmailAddress(String input) {
  int startIndex = input.indexOf('<');
  int endIndex = input.indexOf('>');

  if (startIndex != -1 && endIndex != -1) {
    return input.substring(startIndex + 1, endIndex);
  } else {
    return ''; // Handle cases where the input format doesn't match
  }
}
