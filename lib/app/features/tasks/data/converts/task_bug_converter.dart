import 'package:intl/intl.dart';
import 'package:rns_app/app/features/email/data/converters/importance_converter.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_bug_dto.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_bug.dart';

class TaskBugConverter {
  static TaskBug mapDTO(TaskBugDTO data) => TaskBug(
        id: data.id,
        number: data.number,
        title: data.title,
        active: data.active,
        status: data.status,
        statusTitle: data.statusTitle,
        dateCreate: DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data.dateCreate)),
        executorFio: data.executorFio,
        importance: ImportanceConverter.convert(data.importance),
      );
}
