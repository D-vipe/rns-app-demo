import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_create_form_dto.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_detail_dto.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_dto.dart';
import 'package:rns_app/app/features/tasks/data/requests/create_comment.dart';
import 'package:rns_app/app/features/tasks/data/requests/create_files.dart';
import 'package:rns_app/app/features/tasks/data/requests/create_task_body.dart';
import 'package:rns_app/app/features/tasks/data/requests/edit_task.dart';
import 'package:rns_app/app/features/tasks/data/requests/get_form_data.dart';
import 'package:rns_app/app/features/tasks/data/requests/tasks_list_request.dart';
import 'package:rns_app/configs/data/dio_handler.dart';
import 'package:rns_app/configs/data/endpoints/api_endpoints.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class TasksService {
  final Dio _dio;

  TasksService(this._dio);

  Future<List<TaskDTO>> getTasks({required TasksListRequestBody query}) async {
    List<TaskDTO> result = [];
    try {
      final response = await _dio.get(
        TasksEndpoints.list,
        queryParameters: query.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = response.data['data'].map((json) => TaskDTO.fromJson(json)).toList().cast<TaskDTO>();
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

  Future<List<SelectObjectDTO>> getAvailableProjects() async {
    List<SelectObjectDTO> result = [];
    try {
      final response = await _dio.get(
        TasksEndpoints.listProjects,
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null) {
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

  Future<(List<SelectObjectDTO>, String? noExecutor)> getAvailableUsers() async {
    List<SelectObjectDTO> result = [];
    String? noExecutor;
    try {
      final response = await _dio.get(
        TasksEndpoints.listAvailableExecutors,
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
            noExecutor = response.data['noExecutor'];
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

    return (result, noExecutor);
  }

  Future<List<SelectObjectDTO>> getStatuses() async {
    List<SelectObjectDTO> result = [];
    try {
      final response = await _dio.get(
        TasksEndpoints.listStatuses,
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

  Future<(TaskDetailDTO?, List<SelectObjectDTO>, List<SelectObjectDTO>)> getTaskDetails({required int taskId}) async {
    TaskDetailDTO? taskData;
    List<SelectObjectDTO> editStatusList = [];
    List<SelectObjectDTO> editExecutorList = [];

    try {
      final response = await _dio.get(
        '${TasksEndpoints.detailTaskData}/$taskId',
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              taskData = TaskDetailDTO.fromJson(response.data['data']);
              if (response.data['data']['editStatusList'] != null) {
                editStatusList = response.data['data']['editStatusList']
                    .map((json) => SelectObjectDTO.fromJson(json))
                    .toList()
                    .cast<SelectObjectDTO>();
              }
              if (response.data['data']['editExecutorList'] != null) {
                editExecutorList = response.data['data']['editExecutorList']
                    .map((json) => SelectObjectDTO.fromJson(json))
                    .toList()
                    .cast<SelectObjectDTO>();
              }
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

    return (taskData, editStatusList, editExecutorList);
  }

  Future<List<SelectObjectDTO>?> updateTaskStatus({required EditTaskBody body}) async {
    List<SelectObjectDTO>? result;
    try {
      final response = await _dio.get(
        TasksEndpoints.editStatus,
        queryParameters: body.toJson(),
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
          throw Exception(response.data['message'] ?? 'tasks_error_editStatus'.tr);
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

  Future<bool> updateTaskExecutor({required EditTaskBody body}) async {
    bool result = false;
    try {
      final response = await _dio.get(
        TasksEndpoints.editExecutor,
        queryParameters: body.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        result = response.data['success'];
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

  Future<bool> addNewComment({required NewCommentRequest body}) async {
    bool result = false;
    try {
      final response = await _dio.post(
        TasksEndpoints.addComment,
        data: json.encode(body.toJson()),
      );
      if (DioHandler.checkResponse(response)) {
        result = response.data['success'];
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

  Future<bool> uploadTaskFiles({
    required CreateFilesBody body,
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
        TasksEndpoints.addFile,
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

  Future<TaskCreateFormDTO?> prepareFormData({required GetFormDataBody body}) async {
    TaskCreateFormDTO? result;
    try {
      final response = await _dio.get(
        TasksEndpoints.taskCreate,
        queryParameters: body.toJson(),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = TaskCreateFormDTO.fromJson(response.data['data']);
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

  Future<int?> createTask({required CreateTaskBody body}) async {
    int? result;
    try {
      final response = await _dio.post(
        TasksEndpoints.taskCreate,
        data: json.encode(body.toJson()),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data['success'] == true) {
          if (response.data != null && response.data['data'] != null) {
            try {
              result = response.data['data']['id'];
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
