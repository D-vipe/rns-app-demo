import 'package:rns_app/app/features/tasks/domain/models/task_additional_field.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_create.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class TaskCreateForm {
  final TaskCreate task;
  final List<SelectObject> executors;
  final List<SelectObject> curators;
  final List<SelectObject> taskTypes;
  final List<SelectObject> taskUrgencies;
  final List<SelectObject> taskModules;
  final List<SelectObject> taskSPs;
  final List<SelectObject> projectStages;
  final List<SelectObject> versions;
  final List<SelectObject> taskInitTypes;
  final List<SelectObject> taskLifeCycles;
  final List<TaskAdditionalField> additionalFields;
  final bool isModuleObligatory;
  final bool isSpObligatory;
  final bool isStageObligatory;
  final bool isVersionObligatory;
  final bool isCanNoExecutor;

  const TaskCreateForm({
    required this.task,
    required this.executors,
    required this.curators,
    required this.taskTypes,
    required this.taskUrgencies,
    required this.taskModules,
    required this.taskSPs,
    required this.projectStages,
    required this.versions,
    required this.taskInitTypes,
    required this.taskLifeCycles,
    required this.additionalFields,
    required this.isModuleObligatory,
    required this.isSpObligatory,
    required this.isStageObligatory,
    required this.isVersionObligatory,
    required this.isCanNoExecutor,
  });
}
