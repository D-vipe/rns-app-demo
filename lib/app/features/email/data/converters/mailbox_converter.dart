import 'package:rns_app/app/features/email/data/dto/user_mail_dto.dart';
import 'package:rns_app/app/features/email/domain/models/mailbox_model.dart';

class MailBoxConverter {
  static MailBox mapDTO(MailBoxDTO data) =>
      MailBox(id: data.id, title: data.title, isChecked: data.isChecked, sign: data.sign);
}
