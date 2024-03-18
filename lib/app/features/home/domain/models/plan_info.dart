import 'package:rns_app/app/features/home/domain/models/project_base_info.dart';

class PlanInfo {
  final String? period;
  final DateTime? startDate;
  final DateTime? endDate;
  final int timeCount;
  final bool matching;
  final List<ProjectBaseInfo> projects;

  PlanInfo({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.timeCount,
    required this.matching,
    required this.projects,
  });
}
