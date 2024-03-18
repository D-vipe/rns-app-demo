class TimesheetTasks {
  final int projectId;

  TimesheetTasks({required this.projectId});

  Map<String, dynamic> toJson() => {
    'projectId': projectId
  };
}
