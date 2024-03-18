import 'package:intl/intl.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_dto.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_model.dart';

class TaskConverter {
  static Task mapDTO(TaskDTO data) => Task(
        id: data.id,
        taskName: data.taskName,
        statusTitle: data.statusTitle,
        taskDescription: data.taskDescription,
        projectTitle: data.projectTitle,
        isImportant: data.isImportant,
        isError: data.isError,
        isPrioritet: data.isPrioritet,
        deadLine: data.deadLine != null ? DateTime.parse(data.deadLine!) : null,
        deadLineFormat: data.deadLine != null ? DateFormat('dd.MM.yyyy').format(DateTime.parse(data.deadLine!)) : null,
        isNew: data.isNew,
      );
}
