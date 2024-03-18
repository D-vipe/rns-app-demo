import 'package:intl/intl.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_comment_dto.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_comment.dart';

class TaskCommentConverter {
  static TaskComment mapDTO(TaskCommentDTO data) => TaskComment(
        id: data.id,
        title: data.title,
        number: data.number,
        numberContragent: data.numberContragent ?? 0,
        author: data.author,
        dateCreate: DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data.dateCreate)),
      );
}
