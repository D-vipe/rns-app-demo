import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/general/data/converter/select_object_converter.dart';
import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/app/features/tasks/data/converts/task_converter.dart';
import 'package:rns_app/app/features/tasks/data/converts/task_detail_converter.dart';
import 'package:rns_app/app/features/tasks/data/converts/task_form_converter.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_dto.dart';
import 'package:rns_app/app/features/tasks/data/requests/create_comment.dart';
import 'package:rns_app/app/features/tasks/data/requests/create_files.dart';
import 'package:rns_app/app/features/tasks/data/requests/create_task_body.dart';
import 'package:rns_app/app/features/tasks/data/requests/edit_task.dart';
import 'package:rns_app/app/features/tasks/data/requests/get_form_data.dart';
import 'package:rns_app/app/features/tasks/data/requests/tasks_list_request.dart';
import 'package:rns_app/app/features/general/domain/entities/selected_file_model.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_create_form.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_detail_model.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_model.dart';
import 'package:rns_app/app/features/tasks/domain/models/tasks_filter_model.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class TasksRepository {
  final _service = ApiModule.tasksService();
  final dateFormat = DateFormat('yyyy-MM-dd');

  Future<List<Task>> getTasks({
    int page = 1,
    int limit = 25,
    required TasksFilterModel filter,
  }) async {
    List<Task> result = [];
    try {
      final TasksListRequestBody query = TasksListRequestBody(
        statusId: filter.status?.id != null ? int.parse(filter.status!.id) : null,
        projectId: filter.project?.id != null ? int.parse(filter.project!.id) : null,
        executorId: filter.executor?.id,
        isNewTask: filter.isNewTask,
        pageSize: limit,
        numPage: page,
      );
      final List<TaskDTO> dtoData = await _service.getTasks(query: query);

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => TaskConverter.mapDTO(data)).toList().cast<Task>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<(List<SelectObject>, String?)> getExecutors() async {
    List<SelectObject> result = [];
    String? noExecutor;
    try {
      final (List<SelectObjectDTO>, String?) dtoData = await _service.getAvailableUsers();

      if (dtoData.$1.isNotEmpty) {
        result = dtoData.$1.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
      noExecutor = dtoData.$2;
    } catch (_) {
      rethrow;
    }

    return (result, noExecutor);
  }

  Future<List<SelectObject>> getProjects() async {
    List<SelectObject> result = [];
    try {
      final List<SelectObjectDTO> dtoData = await _service.getAvailableProjects();

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<List<SelectObject>> getStatuses() async {
    List<SelectObject> result = [];
    try {
      final List<SelectObjectDTO> dtoData = await _service.getStatuses();

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<(TaskDetail?, List<SelectObject>, List<SelectObject>)> getTaskDetail({required int taskId}) async {
    TaskDetail? taskData;
    List<SelectObject> editStatusList = [];
    List<SelectObject> editExecutorList = [];
    try {
      final rawData = await _service.getTaskDetails(taskId: taskId);

      try {
        if (rawData.$1 != null) {
          taskData = TaskDetailConverter.mapDTO(rawData.$1!);
        }

        editStatusList = rawData.$2.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
        editExecutorList = rawData.$3.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      } catch (_) {
        throw ParseException('error_convertData'.tr);
      }
    } catch (_) {
      rethrow;
    }

    return (taskData, editStatusList, editExecutorList);
  }

  Future<List<SelectObject>?> editTaskStatus({required int taskId, required int statusId}) async {
    List<SelectObject>? result;
    final EditTaskBody body = EditTaskBody(taskId: taskId, statusId: statusId);
    try {
      final List<SelectObjectDTO>? dtoData = await _service.updateTaskStatus(body: body);

      if (dtoData != null && dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<bool> editTaskExecutor({required int taskId, required String executorId}) async {
    bool result = false;
    final EditTaskBody body = EditTaskBody(taskId: taskId, executorId: executorId);
    try {
      result = await _service.updateTaskExecutor(body: body);
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<bool> addNewComment({required int taskId, required String comment}) async {
    bool result = false;
    final NewCommentRequest body = NewCommentRequest(taskId: taskId, comment: comment);
    try {
      result = await _service.addNewComment(body: body);
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<bool> addFileToTask(
      {required File? pickedFile,
      required AssetEntity? pickedPhoto,
      required int taskId,
      required String comment}) async {
    bool result = false;

    return result;
  }

  Future<bool> uploadTaskFiles({
    required int taskId,
    required int fileTypeId,
    required String description,
    required List<SelectedFile> files,
    required RxInt progressValue,
  }) async {
    bool res = false;
    final CreateFilesBody body = CreateFilesBody(
      taskId: taskId,
      fileTypeId: fileTypeId,
      description: description,
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

      res = await _service.uploadTaskFiles(
        body: body,
        files: convertedFiles,
        progressValue: progressValue,
      );
    } catch (_) {
      rethrow;
    }

    return res;
  }

  Future<TaskCreateForm?> prepareFormData({required String projectId}) async {
    TaskCreateForm? result;
    try {
      final body = GetFormDataBody(projectId: projectId);

      final rawData = await _service.prepareFormData(body: body);
      if (rawData != null) {
        result = TaskCreateFormConverter.mapDTO(rawData);
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<dynamic> createTask({
    required int? id,
    required String projectId,
    required String? taskTypeId,
    required String? urgencyId,
    required String? taskLifecycleId,
    required String? curatorId,
    required String? initiatorId,
    required String? executorId,
    required String? moduleId,
    required String? taskSPId,
    required String? projectStageId,
    required String? versionId,
    required bool isError,
    required bool isPriopritet,
    required String brief,
    required String description,
    required DateTime? deadline,
    required String deadlineTime,
    required DateTime? plannedDate,
    required String plannedDateTime,
    required String planTime,
    required String plannedTimeDevelop,
    required String plannedTimeTest,
    required String? initTypeId,
    required Map<String, String> dopFields,
    required List<String> dopExecutors,
  }) async {
    int? newTaskId;
    try {
      final CreateTaskBody newFormData = CreateTaskBody(
        id: id,
        projectId: int.parse(projectId),
        taskTypeId: taskTypeId != null ? int.parse(taskTypeId) : null,
        urgencyId: urgencyId != null ? int.parse(urgencyId) : null,
        taskLifecycleId: taskLifecycleId != null ? int.parse(taskLifecycleId) : null,
        curatorId: curatorId,
        initiatorId: initiatorId,
        executorId: executorId,
        moduleId: moduleId != null ? int.parse(moduleId) : null,
        taskSPId: taskSPId != null ? int.parse(taskSPId) : null,
        projectStageId: projectStageId != null ? int.parse(projectStageId) : null,
        versionId: versionId != null ? int.parse(versionId) : null,
        isError: isError,
        isPriopritet: isPriopritet,
        initTypeId: initTypeId != null ? int.parse(initTypeId) : null,
        plannedDate: plannedDate != null
            ? DateTime.parse('${dateFormat.format(plannedDate)} ${plannedDateTime.isEmpty ? '10:00' : plannedDateTime}')
            : null,
        planTime: planTime,
        plannedTimeDevelop: plannedTimeDevelop,
        plannedTimeTest: plannedTimeTest,
        dopExecutors: dopExecutors,
        brief: brief,
        description: description,
        deadline: deadline != null
            ? DateTime.parse('${dateFormat.format(deadline)} ${deadlineTime.isEmpty ? '10:00' : deadlineTime}')
            : null,
        dopFields: dopFields,
      );

      final int? result = await _service.createTask(body: newFormData);

      if (result != null) {
        newTaskId = result;
        // Загрузка файлов к задаче
      }
    } catch (_) {
      rethrow;
    }

    return newTaskId;
  }
}
