import 'package:rns_app/app/features/home/data/dto/plan_row_dto.dart';
import 'package:rns_app/app/features/home/domain/models/project_base_info.dart';

class ProjectBaseInfoConverter {
  static ProjectBaseInfo mapDTO(PlanRowDTO data) =>
      ProjectBaseInfo(title: data.projectName, planTime: Duration(minutes: data.countPlan), factTime: Duration(minutes: data.countFact));
}
