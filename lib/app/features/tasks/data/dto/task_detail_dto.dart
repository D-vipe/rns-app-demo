import 'package:rns_app/app/features/tasks/data/dto/task_bug_dto.dart';
import 'package:rns_app/app/features/tasks/data/dto/task_comment_dto.dart';
import 'package:rns_app/app/features/general/data/dto/app_file_dto.dart';

class TaskDetailDTO {
  final int id;
  final String projectTitle;
  final String taskName;
  final String brief;
  final int statusId;
  final String status;
  final String? type;
  final String? urgency;
  final String curator;
  final String? executorId;
  final String? executor;
  final String executorOthers;
  final String initiator;
  final String? module;
  final String? version;
  final String? initReason;
  final String creator;
  final String appointedBy;
  final String deadline;
  final String planDate;
  final String bugCount;
  final int planTime;
  final int factTime;
  final int factTimeWithSubTask;
  final String description;
  final List<AppFileDTO> files;
  final List<TaskCommentDTO> comments;
  final List<TaskBugDTO> bugs;
  final String dateCreate;

  const TaskDetailDTO({
    required this.id,
    required this.projectTitle,
    required this.taskName,
    required this.brief,
    required this.statusId,
    required this.status,
    required this.type,
    required this.urgency,
    required this.curator,
    required this.executorId,
    required this.executor,
    required this.executorOthers,
    required this.initiator,
    required this.module,
    required this.version,
    required this.initReason,
    required this.creator,
    required this.appointedBy,
    required this.deadline,
    required this.planDate,
    required this.planTime,
    required this.factTime,
    required this.factTimeWithSubTask,
    required this.description,
    required this.files,
    required this.comments,
    required this.bugs,
    required this.dateCreate,
    required this.bugCount,
  });

  factory TaskDetailDTO.fromJson(Map<String, dynamic> json) => TaskDetailDTO(
        id: json['id'],
        projectTitle: json['title'],
        taskName: json['taskName'],
        brief: json['brief'],
        statusId: json['statusId'],
        status: json['status'],
        type: json['type'],
        urgency: json['urgency'],
        curator: json['curator'],
        executorId: json['executorId'],
        executor: json['executor'],
        executorOthers: json['executorsOther'],
        initiator: json['initiator'],
        module: json['module'],
        version: json['version'],
        initReason: json['initReason'],
        creator: json['creator'],
        appointedBy: json['appointedBy'],
        deadline: json['deadline'],
        planDate: json['planDate'],
        planTime: json['planTime'],
        factTime: json['factTime'],
        factTimeWithSubTask: json['factTimeWithSubTask'],
        description: json['description'],
        files: json['fileList'] != null
            ? json['fileList'].map((json) => AppFileDTO.fromJson(json)).toList().cast<AppFileDTO>()
            : [],
        comments: json['commentList'] != null
            ? json['commentList'].map((json) => TaskCommentDTO.fromJson(json)).toList().cast<TaskCommentDTO>()
            : [],
        bugs: json['bugList'] != null
            ? json['bugList'].map((json) => TaskBugDTO.fromJson(json)).toList().cast<TaskBugDTO>()
            : [],
        dateCreate: json['dateCreate'],
        bugCount: json['bugCount'],
      );
}
