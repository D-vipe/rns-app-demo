import 'package:rns_app/app/features/tasks/data/dto/task_additional_field_dto.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_additional_field.dart';

class TaskAdditionalFieldConverter {
  static TaskAdditionalField mapDTO(TaskAdditionalFieldDTO data) => TaskAdditionalField(
        id: data.id,
        name: data.name,
        isObligatory: data.isObligatory,
      );
}
