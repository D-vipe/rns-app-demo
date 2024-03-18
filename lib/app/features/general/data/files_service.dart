import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/app/features/general/data/request/download_file_body.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class FilesService {
  final Dio _dio;

  FilesService(this._dio);

  Future<List<int>?> downloadFile({required DownloadFileBody body, required RxString progressValue, required bool email}) async {
    List<int>? result;
    try {
      final response = await _dio.get(
        email ? FileEndpoints.downloadAttachment : FileEndpoints.download,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progressValue.value = (received / total * 100).toStringAsFixed(0);
          }
        },
        queryParameters: body.toJson(),
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (DioHandler.checkResponse(response)) {
        result = response.data;
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

  Future<List<SelectObjectDTO>> getFileTypes() async {
    List<SelectObjectDTO> result = [];
    try {
      final response = await _dio.get(
        FileEndpoints.listType,
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
}
