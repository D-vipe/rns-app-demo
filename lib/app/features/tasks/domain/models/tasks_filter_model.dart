import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class TasksFilterModel {
  final SelectObject? executor;
  final SelectObject? status;
  final SelectObject? project;
  final bool noExecutor;
  final bool? isNewTask;

  const TasksFilterModel({
    required this.executor,
    required this.status,
    required this.project,
    required this.noExecutor,
    required this.isNewTask,
  });

  factory TasksFilterModel.initial() => const TasksFilterModel(
        executor: null,
        isNewTask: false,
        project: null,
        status: null,
        noExecutor: false,
      );

  TasksFilterModel copyWith({
    SelectObject? executor,
    SelectObject? status,
    SelectObject? project,
    bool? noExecutor,
    bool? isNewTask,
  }) =>
      TasksFilterModel(
        executor: executor,
        status: status,
        project: project,
        noExecutor: noExecutor ?? this.noExecutor,
        isNewTask: isNewTask ?? this.isNewTask,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksFilterModel &&
          runtimeType == other.runtimeType &&
          executor == other.executor &&
          status == other.status &&
          project == other.project &&
          noExecutor == other.noExecutor &&
          isNewTask == other.isNewTask;

  @override
  int get hashCode =>
      executor.hashCode ^
      status.hashCode ^
      project.hashCode ^
      noExecutor.hashCode ^
      isNewTask.hashCode;
}
