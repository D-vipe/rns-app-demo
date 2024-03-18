part of 'api_endpoints.dart';

class TimesheetEndpoints {
  TimesheetEndpoints._();

  static const String list = '/api/Timesheet/List';
  static const String getProjects = '/api/Timesheet/DataForNewTimeSheet';
  static const String getParamsByProjectId = '/api/Timesheet/ListParamsByProjectId';
  static const String getTasks = '/api/Timesheet/ListTasks';
  static const String getActivities = '/api/Timesheet/ListWorkTypes';
  static const String createTimeSheet = '/api/Timesheet/save';
  static const String deleteTimeSheet = '/api/Timesheet/delete';
  static const String getAvailableUsers = '/api/Timesheet//ListSelectableEmployees';
}
