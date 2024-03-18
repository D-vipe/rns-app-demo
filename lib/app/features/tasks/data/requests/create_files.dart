class CreateFilesBody {
  final int taskId;
  final int fileTypeId;
  final String description;

  const CreateFilesBody({
    required this.taskId,
    required this.fileTypeId,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'objectId': taskId,
        'fileTypeId': fileTypeId,
        'brief': description,
      };
}
