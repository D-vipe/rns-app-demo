class TaskCreate {
  final int? id;
  final int projectId;
  final int? taskTypeId;
  final int? urgencyId;
  final int? taskLifecycleId;
  final String? curatorId;
  final String? initiatorId;
  final String? executorId;
  final int? moduleId;
  final int? taskSPId;
  final int? projectStageId;
  final int? versionId;
  final bool isError;
  final bool isPriopritet;
  final String? brief;
  final String? description;
  final String? deadline;
  final String? plannedDate;
  final int? planTime;
  final int? plannedTimeDevelop;
  final int? plannedTimeTest;
  final int? initTypeId;
  final dynamic dopFields;
  final List<String> dopExecutors;

  const TaskCreate({
    required this.id,
    required this.projectId,
    required this.taskTypeId,
    required this.urgencyId,
    required this.taskLifecycleId,
    required this.curatorId,
    required this.initiatorId,
    required this.executorId,
    required this.moduleId,
    required this.taskSPId,
    required this.projectStageId,
    required this.versionId,
    required this.isError,
    required this.isPriopritet,
    this.brief,
    this.description,
    this.deadline,
    required this.initTypeId,
    required this.plannedDate,
    required this.planTime,
    required this.plannedTimeDevelop,
    required this.plannedTimeTest,
    this.dopFields,
    required this.dopExecutors,
  });
}
