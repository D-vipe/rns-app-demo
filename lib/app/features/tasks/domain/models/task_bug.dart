import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';

class TaskBug {
  final int id;
  final int number;
  final String title;
  final bool active;
  final bool status;
  final String statusTitle;
  final String executorFio;
  final Importance importance;
  final String dateCreate;

  const TaskBug({
    required this.id,
    required this.number,
    required this.title,
    required this.active,
    required this.status,
    required this.statusTitle,
    required this.dateCreate,
    required this.executorFio,
    required this.importance,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskBug &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          number == other.number &&
          title == other.title &&
          active == other.active &&
          status == other.status &&
          statusTitle == other.statusTitle &&
          executorFio == other.executorFio &&
          importance == other.importance &&
          dateCreate == other.dateCreate;

  @override
  int get hashCode =>
      id.hashCode ^
      number.hashCode ^
      title.hashCode ^
      active.hashCode ^
      status.hashCode ^
      statusTitle.hashCode ^
      executorFio.hashCode ^
      importance.hashCode ^
      dateCreate.hashCode;
}
