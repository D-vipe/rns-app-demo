part of 'api_endpoints.dart';

class TasksEndpoints {
  TasksEndpoints._();

  static const String list = '/api/Task/List';
  static const String detail = '/api/Task/View';
  static const String addFile = '/api/Task/CreateFile';
  static const String addComment = '/api/Task/CreateComment';
  static const String editStatus = '/api/Task/EditStatus';
  static const String editExecutor = '/api/Task/EditExecutor';
  static const String listStatuses = '/api/Task/ListTaskStatus';
  static const String listProjects = '/api/Task/ListProject';
  static const String listAvailableExecutors = '/api/Task/ListExecutor';
  static const String detailTaskData = '/api/Task/View';
  static const String taskCreate = '/api/Task/Create';
}
