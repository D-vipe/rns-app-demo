import 'package:rns_app/app/features/general/data/dto/select_object_dto.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_additional_field_dto.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_create_dto.dart';

class TaskCreateFormDTO {
  final TaskCreateDTO task;
  final List<SelectObjectDTO> executors;
  final List<SelectObjectDTO> curators;
  final List<SelectObjectDTO> taskTypes;
  final List<SelectObjectDTO> taskUrgencies;
  final List<SelectObjectDTO> taskModules;
  final List<SelectObjectDTO> taskSPs;
  final List<SelectObjectDTO> projectStages;
  final List<SelectObjectDTO> versions;
  final List<SelectObjectDTO> taskInitTypes;
  final List<SelectObjectDTO> taskLifeCycles;
  final List<TaskAdditionalFieldDTO> additionalFields;
  final bool isModuleObligatory;
  final bool isSpObligatory;
  final bool isStageObligatory;
  final bool isVersionObligatory;
  final bool isCanNoExecutor;

  const TaskCreateFormDTO({
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

  factory TaskCreateFormDTO.fromJson(Map<String, dynamic> json) => TaskCreateFormDTO(
        task: TaskCreateDTO.fromJson(json['task']),
        executors: json['executors'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        curators: json['curators'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        taskTypes: json['taskTypes'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        taskUrgencies: json['taskUrgencies'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        taskModules: json['taskModules'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        taskSPs: json['taskSPs'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        projectStages: json['projectStages'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        versions: json['versions'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        taskInitTypes: json['taskInitTypes'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        taskLifeCycles: json['taskLifecycles'].map((e) => SelectObjectDTO.fromJson(e)).toList().cast<SelectObjectDTO>(),
        additionalFields: json['additionalFields']
            .map((e) => TaskAdditionalFieldDTO.fromJson(e))
            .toList()
            .cast<TaskAdditionalFieldDTO>(),
        isModuleObligatory: json['isModuleObligatory'] ?? false,
        isSpObligatory: json['isSpObligatory'] ?? false,
        isStageObligatory: json['isStageObligatory'] ?? false,
        isVersionObligatory: json['isVersionObligatory'] ?? false,
        isCanNoExecutor: json['isCanNoExecutor'] ?? false,
      );
}
