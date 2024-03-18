class TaskCreateDTO {
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
  final dynamic dopFields;
  final List<String> dopExecutors;
  final int? initTypeId;
  final String? plannedDate;
  final int? planTime;
  final int? plannedTimeDevelop;
  final int? plannedTimeTest;

  const TaskCreateDTO({
    required this.id,
    required this.projectId,
    required this.taskTypeId,
    required this.urgencyId,
    required this.taskLifecycleId,
    this.curatorId,
    this.initiatorId,
    this.executorId,
    this.moduleId,
    this.taskSPId,
    this.projectStageId,
    this.versionId,
    required this.isError,
    required this.isPriopritet,
    this.brief,
    this.description,
    this.deadline,
    this.dopFields,
    required this.dopExecutors,
    required this.initTypeId,
    required this.plannedDate,
    required this.planTime,
    required this.plannedTimeDevelop,
    required this.plannedTimeTest,
  });

  factory TaskCreateDTO.fromJson(Map<String, dynamic> json) => TaskCreateDTO(
      id: json['id'] ?? 0,
      projectId: json['projectId'],
      taskTypeId: json['taskTypeId'],
      urgencyId: json['urgencyId'],
      taskLifecycleId: json['taskLifecycleId'],
      curatorId: json['curatorId'],
      initiatorId: json['initiatorId'],
      executorId: json['executorId'],
      moduleId: json['moduleId'],
      taskSPId: json['taskSPId'],
      projectStageId: json['projectStageId'],
      versionId: json['versionId'],
      isError: json['isError'] ?? false,
      isPriopritet: json['isPriopritet'] ?? false,
      brief: json['brief'],
      description: json['description'],
      deadline: json['deadline'],
      plannedDate: json['planDate'],
      planTime: json['planTime'],
      plannedTimeDevelop: json['planTimeDesgin'],
      plannedTimeTest: json['planTimeTesting'],
      dopExecutors: json['dopExecutors'] ?? [],
      dopFields: json['dopFields'],
      initTypeId: json['initTypeId']);
}
