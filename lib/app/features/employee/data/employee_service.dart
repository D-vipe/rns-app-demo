import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/employee/data/dto/employee_list_item_dto.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class EmployeeService {
  final Dio _dio;

  EmployeeService(this._dio);

  Future<List<EmployeeListItemDTO>> getEmployees({required Map<String, dynamic> query}) async {
    List<EmployeeListItemDTO> result = [];
    try {
      final Response response = await _dio.get(
        EmployeeEndpoints.list,
        queryParameters: query,
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = response.data['data'].map((json) => EmployeeListItemDTO.fromJson(json)).toList().cast<EmployeeListItemDTO>();
            } catch (e) {
              throw ParseException(e.toString());
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
