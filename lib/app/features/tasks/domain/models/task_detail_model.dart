import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_bug.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_comment.dart';

class TaskDetail {
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
  final String? deadline;
  final String? planDate;
  final int planTime;
  final int factTime;
  final int factTimeWithSubTask;
  final String description;
  final List<AppFile> files;
  final List<TaskComment> comments;
  final List<TaskBug> bugs;
  final String bugCount;
  final String dateCreate;

  const TaskDetail({
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

  TaskDetail copyWith({
    String? executor,
    String? executorId,
    String? status,
    int? statusId,
  }) =>
      TaskDetail(
        id: id,
        projectTitle: projectTitle,
        taskName: taskName,
        brief: brief,
        status: status ?? this.status,
        statusId: statusId ?? this.statusId,
        type: type,
        urgency: urgency,
        curator: curator,
        executor: executor ?? this.executor,
        executorId: executorId ?? this.executorId,
        executorOthers: executorOthers,
        initiator: initiator,
        module: module,
        version: version,
        initReason: initReason,
        creator: creator,
        appointedBy: appointedBy,
        deadline: deadline,
        planDate: planDate,
        planTime: planTime,
        factTime: factTime,
        factTimeWithSubTask: factTimeWithSubTask,
        description: description,
        files: files,
        comments: comments,
        bugs: bugs,
        dateCreate: dateCreate,
        bugCount: bugCount,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          projectTitle == other.projectTitle &&
          taskName == other.taskName &&
          brief == other.brief &&
          statusId == other.statusId &&
          type == other.type &&
          urgency == other.urgency &&
          curator == other.curator &&
          executorId == other.executorId &&
          executor == other.executor &&
          executorOthers == other.executorOthers &&
          initiator == other.initiator &&
          module == other.module &&
          version == other.version &&
          initReason == other.initReason &&
          creator == other.creator &&
          appointedBy == other.appointedBy &&
          deadline == other.deadline &&
          planDate == other.planDate &&
          planTime == other.planTime &&
          factTime == other.factTime &&
          factTimeWithSubTask == other.factTimeWithSubTask &&
          description == other.description &&
          files == other.files &&
          comments == other.comments &&
          bugs == other.bugs &&
          bugCount == other.bugCount &&
          dateCreate == other.dateCreate;

  @override
  int get hashCode =>
      id.hashCode ^
      projectTitle.hashCode ^
      taskName.hashCode ^
      brief.hashCode ^
      statusId.hashCode ^
      status.hashCode ^
      type.hashCode ^
      urgency.hashCode ^
      curator.hashCode ^
      executorId.hashCode ^
      executor.hashCode ^
      executorOthers.hashCode ^
      initiator.hashCode ^
      module.hashCode ^
      version.hashCode ^
      initReason.hashCode ^
      creator.hashCode ^
      appointedBy.hashCode ^
      deadline.hashCode ^
      planDate.hashCode ^
      planTime.hashCode ^
      factTime.hashCode ^
      factTimeWithSubTask.hashCode ^
      description.hashCode ^
      files.hashCode ^
      comments.hashCode ^
      bugs.hashCode ^
      bugCount.hashCode ^
      dateCreate.hashCode;
}
