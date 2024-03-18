import 'package:intl/intl.dart';
import 'package:rns_app/app/features/general/data/converter/app_file_converter.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/features/tasks/data/converts/task_bug_converter.dart';
import 'package:rns_app/app/features/tasks/data/converts/task_comment_converter.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_detail_dto.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_bug.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_comment.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_detail_model.dart';

class TaskDetailConverter {
  static TaskDetail mapDTO(TaskDetailDTO data) => TaskDetail(
        id: data.id,
        projectTitle: data.projectTitle,
        taskName: data.taskName,
        brief: data.brief,
        statusId: data.statusId,
        status: data.status,
        type: data.type,
        urgency: data.urgency,
        curator: data.curator,
        executorId: data.executorId,
        executor: data.executor,
        executorOthers: data.executorOthers,
        initiator: data.initiator,
        module: data.module,
        version: data.version,
        initReason: data.initReason,
        creator: data.creator,
        appointedBy: data.appointedBy,
        deadline: convertAndCheckDate(data.deadline),
        planDate: convertAndCheckDate(data.planDate),
        planTime: data.planTime,
        factTime: data.factTime,
        factTimeWithSubTask: data.factTimeWithSubTask,
        description: data.description,
        files: data.files.map((e) => AppFileConverter.mapDTO(e)).toList().cast<AppFile>(),
        comments: data.comments.map((e) => TaskCommentConverter.mapDTO(e)).toList().cast<TaskComment>(),
        bugs: data.bugs.map((e) => TaskBugConverter.mapDTO(e)).toList().cast<TaskBug>(),
        dateCreate: DateFormat('dd.MM.yyyy').format(DateTime.parse(data.dateCreate)),
        bugCount: data.bugCount,
      );
}

String? convertAndCheckDate(String date) {
  final String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(date));

  return (formattedDate == '01.01.0001') ? null : formattedDate;
}
