import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/email/data/dto/email_dto.dart';
import 'package:rns_app/app/features/email/data/dto/email_item_dto.dart';
import 'package:rns_app/app/features/email/data/dto/user_mail_dto.dart';
import 'package:rns_app/app/features/email/data/requests/batch_action_body.dart';
import 'package:rns_app/app/features/email/data/requests/create_email_body.dart';
import 'package:rns_app/app/features/email/data/requests/email_list_request_body.dart';
import 'package:rns_app/app/features/email/data/requests/importance_query.dart';
import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class EmailService {
  final Dio _dio;

  EmailService(this._dio);

  Future<List<EmailItemDTO>> getEmailList({required EmailListRequestBody query, bool incoming = true}) async {
    List<EmailItemDTO> result = [];
    try {
      final response = await _dio.get(
        incoming ? EmailEndpoints.listIncoming : EmailEndpoints.listOutgoing,
        queryParameters: query.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = response.data['data'].map((json) => EmailItemDTO.fromJson(json)).toList().cast<EmailItemDTO>();
            } catch (_) {
              throw ParseException();
            }
          }
        } else {
          throw Exception(response.data['message'] ?? 'error_general'.tr);
        }
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<EmailDTO?> viewEmailDetail({required int emailId, bool incoming = true}) async {
    EmailDTO? result;
    try {
      final response = await _dio.get(
        incoming ? '${EmailEndpoints.viewIncoming}/$emailId' : '${EmailEndpoints.viewOutgoing}/$emailId',
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = EmailDTO.fromJson(response.data['data']);
            } catch (_) {
              throw ParseException();
            }
          }
        } else {
          throw Exception(response.data['message'] ?? 'error_general'.tr);
        }
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<List<MailBoxDTO>> getAvailableMailBoxes() async {
    List<MailBoxDTO> result = [];
    try {
      final response = await _dio.get(
        EmailEndpoints.personalMailBoxes,
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = response.data['data'].map((json) => MailBoxDTO.fromJson(json)).toList().cast<MailBoxDTO>();
            } catch (_) {
              throw ParseException();
            }
          }
        } else {
          throw Exception(response.data['message'] ?? 'error_general'.tr);
        }
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<List<SelectObjectDTO>> getEmployeesMailBoxes() async {
    List<SelectObjectDTO> result = [];
    try {
      final response = await _dio.get(
        EmailEndpoints.otherMailBoxes,
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result =
                  response.data['data'].map((json) => SelectObjectDTO.fromJson(json)).toList().cast<SelectObjectDTO>();
            } catch (_) {
              throw ParseException();
            }
          }
        } else {
          throw Exception(response.data['message'] ?? 'error_general'.tr);
        }
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<bool> sendEmail({
    required CreateEmailBody body,
    required List<File> files,
    required RxInt progressValue,
  }) async {
    bool result = false;
    try {
      final FormData formData = FormData.fromMap({
        'data': json.encode(body.toJson()),
      });

      for (var file in files) {
        // final String? mimeType = lookupMimeType(file.path);
        late MultipartFile mFile;
        try {
          mFile = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );

          formData.files.add(
            MapEntry('attachments', mFile),
          );
        } catch (e) {
          throw ParseException();
        }
      }

      await _dio.post(
        EmailEndpoints.sendEmail,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
        onSendProgress: (int sent, int total) {
          progressValue.value = ((sent / total) * 100).toInt();
        },
      ).then((Response response) async {
        if (DioHandler.checkResponse(response)) {
          result = response.data['success'] == true;
        }

        if (!result) {
          throw Exception(response.data['message'] ?? 'error_general'.tr);
        }
      });
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<bool> changeImportance({required int emailId, required ImportanceQuery query}) async {
    bool result = false;
    try {
      final response = await _dio.get(
        '${EmailEndpoints.changeImportance}/$emailId',
        queryParameters: query.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        result = response.data['success'] == true;
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<bool> deleteEmail({required int emailId, required bool incoming}) async {
    bool result = false;
    try {
      final response = await _dio.get(
        incoming ? '${EmailEndpoints.deleteIncoming}/$emailId' : '${EmailEndpoints.deleteOutgoing}/$emailId',
      );
      if (DioHandler.checkResponse(response)) {
        result = response.data['success'] == true;
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<bool> toggleRead({required int emailId, required bool markRead}) async {
    bool result = false;
    try {
      final response = await _dio.get(
        markRead ? '${EmailEndpoints.markRead}/$emailId' : '${EmailEndpoints.markUnread}/$emailId',
      );
      if (DioHandler.checkResponse(response)) {
        result = response.data['success'] == true;
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<bool> batchRead({required BatchActionBody body, required bool markRead}) async {
    bool result = false;

    try {
      final response = await _dio.get(
        markRead ? EmailEndpoints.markBatchRead : EmailEndpoints.markBatchUnread,
        queryParameters: body.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        result = response.data['success'] == true;
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }

  Future<bool> deleteEmailMulti({required BatchActionBody body, required bool incoming}) async {
    bool result = false;
    try {
      final response = await _dio.get(
        incoming ? EmailEndpoints.deleteIncomingMulti : EmailEndpoints.deleteOutgoingMulti,
        queryParameters: body.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        result = response.data['success'] == true;
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }

    return result;
  }
}
