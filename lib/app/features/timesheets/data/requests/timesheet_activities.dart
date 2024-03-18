class TimesheetActivities {
  final int projectId;
  final int taskId;

  TimesheetActivities({required this.projectId, required this.taskId});

  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'taskId': taskId,
  };
}
