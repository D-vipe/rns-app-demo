class EditTaskBody {
  final int taskId;
  final int? statusId;
  final String? executorId;

  const EditTaskBody({required this.taskId, this.statusId, this.executorId})
      : assert((statusId != null && executorId == null) || (statusId == null && executorId != null));

  Map<String, dynamic> toJson() => {
        'taskId': taskId,
        if (statusId != null) 'statusId': statusId,
        if (executorId != null) 'executorId': executorId,
      };
}
