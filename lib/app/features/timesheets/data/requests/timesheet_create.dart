import 'package:intl/intl.dart';

class TimeSheetCreateBody {
  final int? id;
  final String comment;
  final int? projectId;
  final int? workTypeId;
  final int? taskId;
  final int? tenderId;
  final int durationMinutes;
  final DateTime date;
  final DateTime start;
  final DateTime end;

  const TimeSheetCreateBody({
    required this.id,
    required this.comment,
    required this.projectId,
    required this.workTypeId,
    required this.taskId,
    this.tenderId,
    required this.durationMinutes,
    required this.date,
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'comment': comment,
        'workTypeId': workTypeId,
        'projectId': projectId,
        'taskId': taskId,
        'durationDay': DateFormat('yyyy-MM-dd').format(date),
        'durationTime': durationMinutes,
        'startTime': DateFormat('dd.MM.yyyy HH:mm').format(start),
        'endTime': DateFormat('dd.MM.yyyy HH:mm').format(end),
        'tenderId': tenderId,
        'ArmRequestId': null,
      };
}
