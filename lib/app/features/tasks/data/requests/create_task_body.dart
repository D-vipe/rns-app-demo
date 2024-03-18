import 'package:intl/intl.dart';
import 'package:rns_app/app/utils/helper_utils.dart';

class CreateTaskBody {
  final int? id;
  final int projectId;
  final int? taskTypeId;
  final int? urgencyId;
  final int? taskLifecycleId;
  final String? curatorId;
  final String? initiatorId;
  final String? executorId;
  final int? moduleId;
  final int? taskSPId;
  final int? projectStageId;
  final int? versionId;
  final bool isError;
  final bool isPriopritet;
  final String? brief;
  final String? description;
  final DateTime? deadline;
  final DateTime? plannedDate;
  final String planTime;
  final String plannedTimeDevelop;
  final String plannedTimeTest;
  final int? initTypeId;
  final Map<String, String> dopFields;
  final List<String> dopExecutors;

  CreateTaskBody({
    required this.id,
    required this.projectId,
    required this.taskTypeId,
    required this.urgencyId,
    required this.taskLifecycleId,
    required this.curatorId,
    required this.initiatorId,
    required this.executorId,
    required this.moduleId,
    required this.taskSPId,
    required this.projectStageId,
    required this.versionId,
    required this.isError,
    required this.isPriopritet,
    required this.brief,
    required this.description,
    required this.deadline,
    required this.initTypeId,
    required this.plannedDate,
    required this.planTime,
    required this.plannedTimeDevelop,
    required this.plannedTimeTest,
    required this.dopFields,
    required this.dopExecutors,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'taskTypeId': taskTypeId,
        'urgencyId': urgencyId,
        'taskLifecycleId': taskLifecycleId,
        'curatorId': curatorId,
        'initiatorId': initiatorId,
        'executorId': executorId,
        'moduleId': moduleId,
        'taskSPId': taskSPId,
        'projectStageId': projectStageId,
        'versionId': versionId,
        'isError': isError,
        'isPriopritet': isPriopritet,
        'brief': brief,
        'description': description,
        'deadline': deadline != null ? DateFormat('yyyy-MM-dd H:mm').format(deadline!) : null,
        'planDate': plannedDate != null ? DateFormat('yyyy-MM-dd H:mm').format(plannedDate!) : null,
        'planTime': HelperUtils.convertStringDurationToMinutes(planTime),
        'planTimeDesgin': HelperUtils.convertStringDurationToMinutes(plannedTimeDevelop),
        'planTimeTesting': HelperUtils.convertStringDurationToMinutes(plannedTimeTest),
        'dopFields': dopFields,
        'dopExecutors': dopExecutors,
      };
}
