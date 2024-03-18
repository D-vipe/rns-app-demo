class Task {
  final int id;
  final String taskName;
  final String? statusTitle;
  final String taskDescription;
  final String projectTitle;
  final bool isImportant;
  final bool isError;
  final bool isPrioritet;
  final DateTime? deadLine;
  final String? deadLineFormat;
  final bool isNew;

  const Task({
    required this.id,
    required this.taskName,
    required this.statusTitle,
    required this.taskDescription,
    required this.projectTitle,
    required this.isImportant,
    required this.isError,
    required this.isPrioritet,
    required this.deadLine,
    required this.deadLineFormat,
    required this.isNew,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          taskName == other.taskName &&
          statusTitle == other.statusTitle &&
          projectTitle == other.projectTitle &&
          taskDescription == other.taskDescription &&
          isImportant == other.isImportant &&
          isError == other.isError &&
          isPrioritet == other.isPrioritet &&
          deadLine == other.deadLine &&
          deadLineFormat == other.deadLineFormat &&
          isNew == other.isNew;

  @override
  int get hashCode =>
      id.hashCode ^
      taskName.hashCode ^
      statusTitle.hashCode ^
      projectTitle.hashCode ^
      taskDescription.hashCode ^
      isImportant.hashCode ^
      isPrioritet.hashCode ^
      isError.hashCode ^
      deadLine.hashCode ^
      deadLineFormat.hashCode ^
      isNew.hashCode;
}
