class TasksListRequestBody {
  final int? statusId;
  final int? projectId;
  final String? executorId;
  final bool? isNewTask;
  final int pageSize;
  final int numPage;

  const TasksListRequestBody({
    required this.statusId,
    this.projectId,
    this.executorId,
    this.isNewTask,
    required this.pageSize,
    required this.numPage,
  });

  Map<String, dynamic> toJson() => {
        'statusId': statusId,
        'projectId': projectId,
        'executorId': executorId,
        'isNewTask': isNewTask ?? false,
        'pageSize': pageSize,
        'numPage': numPage,
      };
}
