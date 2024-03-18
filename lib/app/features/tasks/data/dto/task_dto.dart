class TaskDTO {
  final int id;
  final String taskName;
  final String? statusTitle;
  final String taskDescription;
  final String projectTitle;
  final bool isImportant;
  final bool isError;
  final bool isPrioritet;
  final String? deadLine;
  final bool isNew;

  const TaskDTO({
    required this.id,
    required this.taskName,
    required this.statusTitle,
    required this.taskDescription,
    required this.projectTitle,
    required this.isImportant,
    required this.isError,
    required this.isPrioritet,
    required this.deadLine,
    required this.isNew,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) => TaskDTO(
        id: json['id'],
        taskName: json['taskName'] ?? '',
        statusTitle: json['taskStatusTitle'],
        taskDescription: json['subTitle'] ?? '',
        projectTitle: json['title'] ?? '',
        isImportant: json['isVisibleImportance'],
        isError: json['isError'] ?? false,
        isPrioritet: json['isPriopritet'] ?? false,
        deadLine: json['dateCreate'],
        isNew: json['isNew'],
      );
}
