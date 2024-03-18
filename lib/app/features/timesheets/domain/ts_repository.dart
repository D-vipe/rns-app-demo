import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/general/data/converter/select_object_converter.dart';
import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/app/features/timesheets/data/converters/ts_item_converter.dart';
import 'package:rns_app/app/features/timesheets/data/dto/ts_item_dto.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_activities.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_create.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_filters.dart';
import 'package:rns_app/app/features/timesheets/data/requests/timesheet_tasks.dart';
import 'package:rns_app/app/features/timesheets/domain/models/ts_item_model.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class TimesheetsRepository {
  final _service = ApiModule.timesheetService();

  Future<List<TsItem>> getTimesheets(
      {int page = 1, int limit = 25, required DateTime date, required String executorId}) async {
    List<TsItem> result = [];
    try {
      final TimesheetFilters query = TimesheetFilters(date: date, limit: limit, page: page, executorId: executorId);
      final List<TsItemDTO> dtoData = await _service.getTimesheets(query: query);

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => TsItemConverter.mapDTO(data)).toList().cast<TsItem>();
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<List<SelectObject>> getProjects() async {
    List<SelectObject> result = [];
    try {
      final List<SelectObjectDTO> dtoData = await _service.getProjects();

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }
    return result;
  }

  Future<(List<SelectObject>, List<SelectObject>)> getProjectParams({required int projectId}) async {
    List<SelectObject> tasks = [];
    List<SelectObject> activities = [];
    try {
      final TimesheetTasks query = TimesheetTasks(projectId: projectId);
      final (List<SelectObjectDTO>, List<SelectObjectDTO>) dtoData = await _service.getProjectParams(query: query);

      if (dtoData.$1.isNotEmpty) {
        tasks = dtoData.$1.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }

      if (dtoData.$2.isNotEmpty) {
        activities = dtoData.$2.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }
    return (tasks, activities);
  }

  Future<List<SelectObject>> getTasks({required int projectId}) async {
    List<SelectObject> result = [];
    try {
      final TimesheetTasks query = TimesheetTasks(projectId: projectId);
      final List<SelectObjectDTO> dtoData = await _service.getTasks(query: query);

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }
    return result;
  }

  Future<List<SelectObject>> getActivities({required int projectId, required int taskId}) async {
    List<SelectObject> result = [];
    try {
      final TimesheetActivities query = TimesheetActivities(projectId: projectId, taskId: taskId);
      final List<SelectObjectDTO> dtoData = await _service.getActivities(query: query);

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }
    return result;
  }

  Future<List<SelectObject>> getAvailableUsers() async {
    List<SelectObject> result = [];
    try {
      final List<SelectObjectDTO> dtoData = await _service.getAvailableUsers();

      if (dtoData.isNotEmpty) {
        result = dtoData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      }
    } catch (_) {
      rethrow;
    }
    return result;
  }

  Future<bool> createTimeSheet({
    required int projectId,
    required int taskId,
    required int workTypeId,
    required DateTime date,
    required DateTime start,
    required DateTime end,
    required String comment,
    int? tsId,
  }) async {
    bool res = false;

    try {
      final TimeSheetCreateBody body = TimeSheetCreateBody(
        id: tsId,
        comment: comment,
        projectId: projectId,
        workTypeId: workTypeId,
        taskId: taskId,
        date: date,
        durationMinutes: end.difference(start).inMinutes,
        start: start,
        end: end,
      );

      res = await _service.createTimeSheet(body: body);
    } catch (_) {
      rethrow;
    }

    return res;
  }

  Future<bool> deleteTimeSheet({
    required int id,
  }) async {
    bool res = false;

    try {
      res = await _service.deleteTimeSheet(id: id);
    } catch (_) {
      rethrow;
    }

    return res;
  }
}
