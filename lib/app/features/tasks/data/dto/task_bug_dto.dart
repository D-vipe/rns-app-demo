class TaskBugDTO {
  final int id;
  final int number;
  final String title;
  final bool active;
  final bool status;
  final int importance;
  final String executorFio;
  final String statusTitle;
  final String dateCreate;

  const TaskBugDTO({
    required this.id,
    required this.number,
    required this.title,
    required this.active,
    required this.status,
    required this.statusTitle,
    required this.dateCreate,
    required this.importance,
    required this.executorFio,
  });

  factory TaskBugDTO.fromJson(Map<String, dynamic> json) => TaskBugDTO(
        id: json['id'],
        number: json['number'],
        title: json['title'],
        active: json['active'],
        status: json['status'],
        statusTitle: json['statusTitle'],
        dateCreate: json['dateCreate'],
        importance: json['importance'],
        executorFio: json['executorFio'],
      );
}
