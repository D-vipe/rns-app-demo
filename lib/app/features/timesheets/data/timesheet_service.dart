import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/app/features/timesheets/data/dto/ts_item_dto.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_activities.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_create.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_filters.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_tasks.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class TimesheetsService {
  final Dio _dio;

  TimesheetsService(this._dio);

  Future<List<TsItemDTO>> getTimesheets({required TimesheetFilters query}) async {
    List<TsItemDTO> result = [];
    try {
      final Response response = await _dio.get(
        TimesheetEndpoints.list,
        queryParameters: query.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = response.data['data'].map((json) => TsItemDTO.fromJson(json)).toList().cast<TsItemDTO>();
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

  Future<List<SelectObjectDTO>> getProjects() async {
    List<SelectObjectDTO> result = [];
    try {
      final Response response = await _dio.get(
        TimesheetEndpoints.getProjects,
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data']['projects'] != null) {
            try {
              result = response.data['data']['projects']
                  .map((json) => SelectObjectDTO.fromJson(json))
                  .toList()
                  .cast<SelectObjectDTO>();
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

  Future<(List<SelectObjectDTO>, List<SelectObjectDTO>)> getProjectParams({required TimesheetTasks query}) async {
    (List<SelectObjectDTO>, List<SelectObjectDTO>) result = ([], []);
    List<SelectObjectDTO> tasks = [];
    List<SelectObjectDTO> activities = [];
    try {
      final Response response = await _dio.get(
        '${TimesheetEndpoints.getParamsByProjectId}/${query.projectId}',
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data']['tasks'] != null) {
            try {
              tasks = response.data['data']['tasks']
                  .map((json) => SelectObjectDTO.fromJson(json))
                  .toList()
                  .cast<SelectObjectDTO>();
            } catch (_) {
              throw ParseException('timeSheets_error_parseTasks'.tr);
            }
          }

          if (response.data != null && response.data['data']['work_types'] != null) {
            try {
              activities = response.data['data']['work_types']
                  .map((json) => SelectObjectDTO.fromJson(json))
                  .toList()
                  .cast<SelectObjectDTO>();
            } catch (_) {
              throw ParseException('timeSheets_error_parseActivities'.tr);
            }
          }
        } else {
          throw Exception(response.data['message'] ?? 'error_general'.tr);
        }

        result = (tasks, activities);
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

  Future<List<SelectObjectDTO>> getTasks({required TimesheetTasks query}) async {
    List<SelectObjectDTO> result = [];
    try {
      final Response response = await _dio.get(
        TimesheetEndpoints.getTasks,
        queryParameters: query.toJson(),
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

  Future<List<SelectObjectDTO>> getActivities({required TimesheetActivities query}) async {
    List<SelectObjectDTO> result = [];
    try {
      final Response response = await _dio.get(
        TimesheetEndpoints.getActivities,
        queryParameters: query.toJson(),
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

  Future<List<SelectObjectDTO>> getAvailableUsers() async {
    List<SelectObjectDTO> result = [];
    try {
      final Response response = await _dio.get(
        TimesheetEndpoints.getAvailableUsers,
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

  Future<bool> createTimeSheet({required TimeSheetCreateBody body}) async {
    bool res = false;
    try {
      final Response response = await _dio.post(
        TimesheetEndpoints.createTimeSheet,
        data: jsonEncode(body.toJson()),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          res = response.data['success'] ?? false;
        }
      }

      if (!res) {
        throw Exception(response.data['message'] ?? 'error_general'.tr);
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }
    return res;
  }

  Future<bool> deleteTimeSheet({required int id}) async {
    bool res = false;
    try {
      final Response response = await _dio.get(
        '${TimesheetEndpoints.deleteTimeSheet}/$id',
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          res = response.data['success'] ?? false;
        }
      }

      if (!res) {
        throw Exception(response.data['message'] ?? 'error_general'.tr);
      }
    } catch (e) {
      if (e is DioException) {
        throw ConnectionException();
      } else {
        rethrow;
      }
    }
    return res;
  }
}
