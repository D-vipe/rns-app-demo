import 'dart:io';

import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/email/data/converters/email_converter.dart';
import 'package:rns_app/app/features/email/data/converters/email_item_converter.dart';
import 'package:rns_app/app/features/email/data/converters/mailbox_converter.dart';
import 'package:rns_app/app/features/email/data/dto/email_dto.dart';
import 'package:rns_app/app/features/email/data/dto/email_item_dto.dart';
import 'package:rns_app/app/features/email/data/requests/batch_action_body.dart';
import 'package:rns_app/app/features/email/data/requests/create_email_body.dart';
import 'package:rns_app/app/features/email/data/requests/email_list_request_body.dart';
import 'package:rns_app/app/features/email/data/requests/importance_query.dart';
import 'package:rns_app/app/features/email/domain/models/email_filter_model.dart';
import 'package:rns_app/app/features/email/domain/models/email_list_item.dart';
import 'package:rns_app/app/features/email/domain/models/email_model.dart';
import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/features/email/domain/models/mailbox_model.dart';
import 'package:rns_app/app/features/general/data/converter/select_object_converter.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/features/general/domain/entities/selected_file_model.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/helper_utils.dart';

class EmailRepository {
  final _service = ApiModule.emailService();

  Future<List<EmailListItem>> getEmails({
    int page = 1,
    int limit = 25,
    required EmailFilterModel filter,
    required bool incoming,
  }) async {
    List<EmailListItem> result = [];
    try {
      final EmailListRequestBody query = EmailListRequestBody(
        recipientId: filter.recepient?.id,
        mailboxId: null,
        dateFrom: filter.dateFrom,
        dateTo: filter.dateTo,
        importance: filter.importance.map((e) => Uri.encodeComponent("'${e.apiValue}'")).toList().join(','),
        searchTerm: filter.searchTitle,
        onlyUnread: filter.onlyUnread,
        pageSize: limit,
        numPage: page,
      );
      final List<EmailItemDTO> dtoData = await _service.getEmailList(query: query, incoming: incoming);

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => EmailItemConverter.mapDTO(data)).toList().cast<EmailListItem>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<Email?> getEmailDetail({required int id, bool incoming = true}) async {
    Email? result;
    try {
      final EmailDTO? rawResult = await _service.viewEmailDetail(emailId: id, incoming: incoming);
      if (rawResult != null) {
        result = EmailConverter.mapDTO(rawResult);
      }

      // Обработаем Attachment, если он есть и добавим значение иконки, которую будем отображать
      if (result != null && result.fileData.isNotEmpty) {
        List<AppFile> processedAttachments = [];
        for (var attachment in result.fileData) {
          late AppFile updatedAttachment;

          final String? fileIcon = HelperUtils.getFileIconFromNameExtension(attachment.title);

          if (fileIcon != null) {
            updatedAttachment = attachment.copyWith(iconPath: fileIcon);
          } else {
            updatedAttachment = attachment;
          }

          // Преобразуем название файла. Если длина заголовка более 18 символов, то вырежем лишнее.
          // Возмьмем первые 6 символов и 6 последних (включая расширение, если оно имеется)
          // Между ними добавим три точки
          updatedAttachment = updatedAttachment.copyWith(title: HelperUtils.shortenFileName(updatedAttachment.title));

          processedAttachments.add(updatedAttachment);
        }

        if (processedAttachments.isNotEmpty) {
          result = result.copyWith(fileData: processedAttachments);
        }
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<List<MailBox>> getAvailableBoxes() async {
    List<MailBox> result = [];
    try {
      final dtoData = await _service.getAvailableMailBoxes();

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => MailBoxConverter.mapDTO(data)).toList().cast<MailBox>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<List<SelectObject>> getEmployeeBoxes() async {
    List<SelectObject> result = [];
    try {
      final dtoData = await _service.getEmployeesMailBoxes();

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<bool> sendEmail({
    required int fromMailboxId,
    required String to,
    required String copy,
    required String copyHide,
    required String theme,
    required String body,
    required String footer,
    required List<SelectedFile> files,
    DateTime? sendDate,
    String? sendTime,
    int? parentIncomingId,
    int? parentOutgoingId,
    required RxInt progressValue,
  }) async {
    bool result = false;

    String? formatedSendDateTime;

    if (sendDate != null && sendTime != null) {
      formatedSendDateTime = '${DateFormat('yyyy-MM-dd').format(sendDate)} $sendTime';
    }

    final CreateEmailBody requestBody = CreateEmailBody(
      theme: theme,
      fromMailboxId: fromMailboxId,
      to: to,
      copy: copy,
      copyHide: copyHide,
      body: body,
      footer: footer,
      sendDateTime: formatedSendDateTime,
      parentIncomingId: parentIncomingId,
      parentOutgoingId: parentOutgoingId,
    );

    try {
      // List of converted files from AssetEntity
      final List<File> convertedFiles = [];
      for (var item in files) {
        if (item.pickedFile != null) convertedFiles.add(item.pickedFile!);
        if (item.pickedPhoto != null) {
          final File? converted = await item.pickedPhoto!.file;
          if (converted != null) convertedFiles.add(converted);
        }
      }

      result = await _service.sendEmail(
        body: requestBody,
        files: convertedFiles,
        progressValue: progressValue,
      );
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<EmailListItem> changeImportance({required EmailListItem email}) async {
    try {
      final ImportanceQuery query = ImportanceQuery(importance: email.importance);
      final bool res = await _service.changeImportance(emailId: email.id, query: query);
      if (res) {
        email = email.copyWith(
            importance: email.importance == Importance.no ? Importance.high : Importance.no);
      }
    } catch (_) {
      rethrow;
    }

    return email;
  }

  Future<EmailListItem> toggleRead({required EmailListItem email}) async {
    try {
      final bool res = await _service.toggleRead(emailId: email.id, markRead: email.unread);
      if (res) {
        email = email.copyWith(unread: !email.unread);
      }
    } catch (_) {
      rethrow;
    }

    return email;
  }

  Future<bool> deleteEmail({required int emailId, required bool incoming}) async {
    bool res = false;
    try {
      res = await _service.deleteEmail(emailId: emailId, incoming: incoming);
    } catch (_) {
      rethrow;
    }

    return res;
  }

  Future<List<EmailListItem>> batchToggleRead({required List<EmailListItem> items, required bool markRead}) async {
    try {
      final BatchActionBody body = BatchActionBody(ids: items.map((e) => e.id).toList());

      final bool res = await _service.batchRead(body: body, markRead: markRead);
      if (res) {
        for (var i = 0; i < items.length; i++) {
          items[i] = items[i].copyWith(unread: markRead ? false : true);
        }
      }
    } catch (_) {
      rethrow;
    }

    return items;
  }

  Future<bool> deleteEmailMulti({required List<EmailListItem> items, required bool incoming}) async {
    bool res = false;
    try {
      final BatchActionBody body = BatchActionBody(ids: items.map((e) => e.id).toList());
      res = await _service.deleteEmailMulti(body: body, incoming: incoming);
    } catch (_) {
      rethrow;
    }

    return res;
  }
}
