class TsItem {
  final int id;
  final int timeDuration; // время в минутах!
  final String taskName;
  final String projectTitle;
  final String description;
  final String workTypeName;
  final String timeGap;
  final DateTime dateCreate;
  bool overlapping = false;

  TsItem({
    required this.id,
    required this.timeDuration,
    required this.taskName,
    required this.projectTitle,
    required this.description,
    required this.workTypeName,
    required this.timeGap,
    required this.dateCreate,
    required this.overlapping,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TsItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timeDuration == other.timeDuration &&
          taskName == other.taskName &&
          projectTitle == other.projectTitle &&
          description == other.description &&
          workTypeName == other.workTypeName &&
          timeGap == other.timeGap &&
          overlapping == other.overlapping &&
          dateCreate == other.dateCreate;

  @override
  int get hashCode =>
      id.hashCode ^
      timeDuration.hashCode ^
      taskName.hashCode ^
      projectTitle.hashCode ^
      description.hashCode ^
      workTypeName.hashCode ^
      timeGap.hashCode ^
      overlapping.hashCode ^
      dateCreate.hashCode;
}
