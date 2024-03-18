import 'package:rns_app/app/features/home/data/converters/project_base_info_converter.dart';
import 'package:rns_app/app/features/home/data/dto/plan_info_dto.dart';
import 'package:rns_app/app/features/home/domain/models/plan_info.dart';
import 'package:rns_app/app/features/home/domain/models/project_base_info.dart';
import 'package:rns_app/app/utils/extensions.dart';

class PlanInfoConverter {
  static PlanInfo mapDTO(PlanInfoDTO data) => PlanInfo(
        period: data.period,
        startDate: data.period != null ? DateTime.parse(data.period!.split(' - ').first.convertStringDate()) : null,
        endDate: data.period != null ? DateTime.parse(data.period!.split(' - ').last.convertStringDate()) : null,
        timeCount: data.countHours,
        matching: data.isConfirmed,
        projects: data.rows.isNotEmpty
            ? data.rows.map((e) => ProjectBaseInfoConverter.mapDTO(e)).toList().cast<ProjectBaseInfo>()
            : [],
      );
}
