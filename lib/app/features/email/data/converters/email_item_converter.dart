import 'package:rns_app/app/features/email/data/converters/importance_converter.dart';
import 'package:rns_app/app/features/email/data/dto/email_item_dto.dart';
import 'package:rns_app/app/features/email/domain/models/email_list_item.dart';

class EmailItemConverter {
  static EmailListItem mapDTO(EmailItemDTO data) => EmailListItem(
        id: data.id,
        title: data.title,
        subTitle: data.subTitle,
        importance: ImportanceConverter.convert(data.importance),
        hasAttachment: data.isVisibleRightIcon,
        created: DateTime.parse(data.created),
        unread: data.isBoldTitle,
      );
}

