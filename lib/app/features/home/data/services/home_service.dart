import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/home/data/dto/directions_dto.dart';
import 'package:rns_app/app/features/home/data/dto/news_item_dto.dart';
import 'package:rns_app/app/features/home/data/dto/plan_info_dto.dart';
import 'package:rns_app/app/features/home/data/dto/user_dto.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class HomeService {
  final Dio _dio;

  HomeService(this._dio);

  Future<UserDTO?> getUserData() async {
    UserDTO? result;
    try {
      Response response = await _dio.get(
        EmployeeEndpoints.info,
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data != null && response.data['data'] != null) {
          try {
            result = UserDTO.fromJson(response.data['data']);
          } catch (_) {
            throw ParseException();
          }
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

  Future<(NewsItemDTO?, PlanInfoDTO?, List<DirectionDTO>)> getMainScreen() async {
    NewsItemDTO? news;
    PlanInfoDTO? plan;
    List<DirectionDTO> directions = [];
    List<String> errors = [];
    try {
      final Response response = await _dio.get(
        EmployeeEndpoints.main,
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              if (response.data['data']['news'] != null) {
                news = NewsItemDTO.fromJson(response.data['data']['news']);
              }
            } catch (_) {
              errors.add('home_error_parseNews'.tr);
            }

            try {
              if (response.data['data']['currentPlan'] != null) {
                plan = PlanInfoDTO.fromJson(response.data['data']['currentPlan']);
              }
            } catch (_) {
              errors.add('home_error_parsePlan'.tr);
            }

            try {
              if (response.data['data']['text'] != null) {
                directions = response.data['data']['text']
                    .map((json) => DirectionDTO.fromJson(json))
                    .toList()
                    .cast<DirectionDTO>();
              }
            } catch (_) {
              errors.add('home_error_parseDirections'.tr);
            }
          }

          if (errors.isNotEmpty) {
            final combinedError = errors.join('\n');
            throw ParseException(combinedError);
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

    return (news, plan, directions);
  }
}
