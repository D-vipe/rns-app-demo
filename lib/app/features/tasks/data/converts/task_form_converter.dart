import 'package:rns_app/app/features/general/data/converter/select_object_converter.dart';
import 'package:rns_app/app/features/tasks/data/converts/task_additional_field_converter.dart';
import 'package:rns_app/app/features/tasks/data/converts/task_create_converter.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_create_form_dto.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_additional_field.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_create_form.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class TaskCreateFormConverter {
  static TaskCreateForm mapDTO(TaskCreateFormDTO data) => TaskCreateForm(
        task: TaskCreateConverter.mapDTO(data.task),
        executors: data.executors.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        curators: data.curators.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        taskTypes: data.taskTypes.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        taskUrgencies: data.taskUrgencies.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        taskModules: data.taskModules.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        taskSPs: data.taskSPs.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        projectStages: data.projectStages.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        versions: data.versions.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        taskInitTypes: data.taskInitTypes.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        taskLifeCycles: data.taskLifeCycles.map((e) => SelectObjectConverter.mapDTO(e)).toList().cast<SelectObject>(),
        additionalFields: data.additionalFields
            .map((e) => TaskAdditionalFieldConverter.mapDTO(e))
            .toList()
            .cast<TaskAdditionalField>(),
        isModuleObligatory: data.isModuleObligatory,
        isSpObligatory: data.isSpObligatory,
        isStageObligatory: data.isStageObligatory,
        isVersionObligatory: data.isVersionObligatory,
        isCanNoExecutor: data.isCanNoExecutor,
      );
}
