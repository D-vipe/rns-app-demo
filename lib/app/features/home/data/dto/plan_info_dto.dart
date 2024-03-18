import 'package:rns_app/app/features/home/data/dto/plan_row_dto.dart';

class PlanInfoDTO {
  final String? period;
  final String? projectName;
  final String? employeeName;
  final String? comment;
  final int countHours;
  final bool isConfirmed;
  final List<PlanRowDTO> rows;

  const PlanInfoDTO({
    this.period,
    this.projectName,
    this.employeeName,
    this.comment,
    required this.countHours,
    required this.isConfirmed,
    required this.rows,
  });

  factory PlanInfoDTO.fromJson(Map<String, dynamic> json) => PlanInfoDTO(
        period: json['period'],
        projectName: json['projectName'],
        employeeName: json['employeeName'],
        countHours: json['countHours'],
        comment: json['comment'],
        isConfirmed: json['isConfirmed'],
        rows:
            json['rows'] != null ? json['rows'].map((row) => PlanRowDTO.fromJson(row)).toList().cast<PlanRowDTO>() : [],
      );
}
